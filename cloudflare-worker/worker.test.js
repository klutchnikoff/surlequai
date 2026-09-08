import { test, afterEach } from 'node:test';
import assert from 'node:assert/strict';
import worker from './worker.js';

const originalFetch = globalThis.fetch;
afterEach(() => { globalThis.fetch = originalFetch; });
const context = { waitUntil(promise) { promise.catch(() => {}); } };
function environment(limit = async () => ({ success: true })) {
  return { NAVITIA_API_KEY: 'test-key', RATE_LIMITER: { limit },
    STATS_KV: { get: async () => null, put: async () => {} } };
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
