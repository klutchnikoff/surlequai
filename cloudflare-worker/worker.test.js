import { test, afterEach } from 'node:test';
import assert from 'node:assert/strict';
import worker from './worker.js';

const originalFetch = globalThis.fetch;
const pending = [];
afterEach(() => { globalThis.fetch = originalFetch; delete globalThis.caches; pending.length = 0; });
const context = { waitUntil(promise) { pending.push(promise.catch(() => {})); } };
const settled = () => Promise.all(pending.splice(0));
function environment(limit = async () => ({ success: true })) {
  return { NAVITIA_API_KEY: 'test-key', RATE_LIMITER: { limit },
    STATS: { writeDataPoint() {} } };
}
// Cache de test : la réponse rangée n'est jamais consommée, seules ses copies le sont.
function installCache() {
  const store = new Map();
  globalThis.caches = { default: {
    async match(request) { const hit = store.get(request.url); return hit && hit.clone(); },
    async put(request, response) { store.set(request.url, response); },
  } };
  return store;
}

test('forwards only authentication and Accept, with one slash after v1', async () => {
  let outbound;
  globalThis.fetch = async (url, options) => {
    outbound = { url, options };
    return new Response('{}', { headers: { 'Set-Cookie': 'private=value' } });
  };
  const request = new Request('https://proxy.test/coverage/sncf/journeys?from=A&to=B', {
    headers: { 'CF-Connecting-IP': '192.0.2.1', 'X-Forwarded-For': '192.0.2.1',
      Cookie: 'secret', Authorization: 'user-token', 'User-Agent': 'personal-agent' },
  });
  const response = await worker.fetch(request, environment(), context);
  assert.equal(response.status, 200);
  assert.equal(outbound.url, 'https://api.sncf.com/v1/coverage/sncf/journeys?from=A&to=B');
  assert.deepEqual(outbound.options.headers, { Authorization: `Basic ${btoa('test-key:')}`, Accept: 'application/json' });
  assert.equal(response.headers.get('Set-Cookie'), null);
});

test('supports the historical /api/ prefix', async () => {
  globalThis.fetch = async url => { assert.equal(url, 'https://api.sncf.com/v1/coverage/sncf/places?q=Paris'); return new Response('{}'); };
  assert.equal((await worker.fetch(new Request('https://proxy.test/api/coverage/sncf/places?q=Paris'), environment(), context)).status, 200);
});

test('delegates the window to the native limiter and never sends plain IP', async () => {
  let key;
  const env = environment(async args => { key = args.key; return { success: false }; });
  globalThis.fetch = async () => { assert.fail('No upstream request when rate limited'); };
  const response = await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys', {
    headers: { 'CF-Connecting-IP': '192.0.2.1' },
  }), env, context);
  assert.equal(response.status, 429);
  assert.match(key, /^[a-f0-9]{64}$/);
  assert.equal(response.headers.get('Retry-After'), '60');
});

test('missing limiter does not consume upstream quota', async () => {
  const env = environment(); delete env.RATE_LIMITER;
  assert.equal((await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys'), env, context)).status, 503);
});

test('rejects unexpected routes and writes before upstream', async () => {
  globalThis.fetch = async () => assert.fail('Unexpected upstream call');
  assert.equal((await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys', { method: 'POST' }), environment(), context)).status, 405);
  assert.equal((await worker.fetch(new Request('https://proxy.test/other'), environment(), context)).status, 404);
});

test('upstream errors do not expose internal details', async () => {
  globalThis.fetch = async () => { throw new Error('secret diagnostic'); };
  const response = await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys'), environment(), context);
  assert.equal(response.status, 502);
  assert.doesNotMatch(await response.text(), /secret/);
});

test('truncates the seconds so a whole minute shares one upstream call', async () => {
  const seen = [];
  globalThis.fetch = async url => { seen.push(url); return new Response('{}'); };
  await worker.fetch(new Request('https://proxy.test/coverage/sncf/stop_areas/A/departures?from_datetime=20260908T211732&count=10'), environment(), context);
  await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys?datetime=20260908T211705&from=A'), environment(), context);
  assert.equal(seen[0], 'https://api.sncf.com/v1/coverage/sncf/stop_areas/A/departures?from_datetime=20260908T211700&count=10');
  assert.equal(seen[1], 'https://api.sncf.com/v1/coverage/sncf/journeys?datetime=20260908T211700&from=A');
});

test('serves a second caller from the shared cache without calling upstream', async () => {
  installCache();
  let calls = 0;
  globalThis.fetch = async () => { calls += 1; return new Response('{"departures":[]}'); };
  const url = 'https://proxy.test/coverage/sncf/stop_areas/A/departures?from_datetime=20260908T211710';
  const first = await worker.fetch(new Request(url), environment(), context);
  await settled();
  // Une seconde plus tard, l'URL amont normalisée est la même.
  const second = await worker.fetch(new Request(url.replace('211710', '211759')), environment(), context);
  assert.equal(calls, 1);
  assert.equal(first.headers.get('X-Cache'), 'MISS');
  assert.equal(second.headers.get('X-Cache'), 'HIT');
  assert.equal(await second.text(), '{"departures":[]}');
});

test('keeps stations for a day and schedules for a minute', async () => {
  const store = installCache();
  globalThis.fetch = async () => new Response('{}');
  await worker.fetch(new Request('https://proxy.test/coverage/sncf/places?q=Rennes'), environment(), context);
  await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys?from=A'), environment(), context);
  await settled();
  const ttl = url => store.get(url).headers.get('Cache-Control');
  assert.equal(ttl('https://api.sncf.com/v1/coverage/sncf/places?q=Rennes'), 'max-age=86400');
  assert.equal(ttl('https://api.sncf.com/v1/coverage/sncf/journeys?from=A'), 'max-age=60');
});

test('refuses to follow an upstream redirect', async () => {
  const store = installCache();
  globalThis.fetch = async (_url, options) => {
    assert.equal(options.redirect, 'manual');
    return new Response(null, { status: 302, headers: { Location: 'https://elsewhere.test/' } });
  };
  const response = await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys?from=A'), environment(), context);
  await settled();
  assert.equal(response.status, 502);
  assert.equal(response.headers.get('Location'), null);
  assert.equal(store.size, 0);
});

test('never shares an upstream failure', async () => {
  const store = installCache();
  globalThis.fetch = async () => new Response('{"error":"quota"}', { status: 429 });
  const response = await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys?from=A'), environment(), context);
  await settled();
  assert.equal(response.status, 429);
  assert.equal(store.size, 0);
});

test('a client is still served when the cache is unavailable', async () => {
  globalThis.caches = { default: {
    async match() { throw new Error('cache down'); },
    put() { throw new Error('cache down'); },
  } };
  let calls = 0;
  globalThis.fetch = async () => { calls += 1; return new Response('{"departures":[]}'); };
  const response = await worker.fetch(new Request('https://proxy.test/coverage/sncf/journeys?from=A'), environment(), context);
  await settled();
  assert.equal(response.status, 200);
  assert.equal(calls, 1);
  assert.equal(await response.text(), '{"departures":[]}');
});
