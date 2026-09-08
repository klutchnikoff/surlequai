/** Proxy SNCF : aucun en-tête utilisateur n'est transmis à l'amont. */
const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

const route = /^\/coverage\/sncf\/(journeys|places|stop_areas\/[^/]+\/departures)$/;

// Durées du cache partagé. Les gares ne bougent pas d'un jour à l'autre ; les
// horaires sont réinterrogés chaque minute par l'application.
const cacheTtl = { places: 86400, realtime: 60 };

function errorResponse(status, message, headers = {}) {
  return new Response(JSON.stringify({ error: message }), {
    status, headers: { ...cors, 'Content-Type': 'application/json', ...headers },
  });
}

export default {
  async fetch(request, env, ctx) {
    if (request.method === 'OPTIONS') return new Response(null, { status: 204, headers: cors });
    if (request.method !== 'GET') return errorResponse(405, 'Method not allowed', { Allow: 'GET, OPTIONS' });
    const url = new URL(request.url);
    const path = url.pathname.replace(/^\/api\//, '/');
    // Le proxy expose seulement les ressources utilisées par l'application.
    const matched = route.exec(path);
    if (!matched) return errorResponse(404, 'Unknown endpoint');
    try {
      const key = await rateLimitKey(request, env.NAVITIA_API_KEY);
      const { success } = await env.RATE_LIMITER.limit({ key });
      if (!success) return errorResponse(429, 'Too many requests', { 'Retry-After': '60' });
    } catch (_) {
      return errorResponse(503, 'Rate limiter unavailable', { 'Retry-After': '60' });
    }
    const upstreamUrl = `https://api.sncf.com/v1${path}${normalizeSearch(url.search)}`;
    // La clé ne porte aucun en-tête : deux clients qui demandent la même
    // ressource pendant la même minute partagent la même entrée.
    const cache = sharedCache();
    const cacheKey = cache && new Request(upstreamUrl, { method: 'GET' });
    // Un cache en panne ne doit jamais priver l'utilisateur de ses horaires :
    // on retombe simplement sur un appel amont.
    const hit = cache && await cache.match(cacheKey).catch(() => null);
    if (hit) {
      record(env, 'hit');
      return clientResponse(hit, 'HIT');
    }
    try {
      const upstream = await fetch(upstreamUrl, {
        method: 'GET',
        headers: {
          Authorization: `Basic ${btoa(env.NAVITIA_API_KEY + ':')}`,
          Accept: 'application/json',
        },
        redirect: 'error',
        signal: AbortSignal.timeout(9000),
      });
      // Seules les réponses complètes sont partagées : une erreur amont ne doit
      // pas être resservie à tous les utilisateurs pendant la durée du cache.
      if (cache && upstream.status === 200) {
        const ttl = matched[1] === 'places' ? cacheTtl.places : cacheTtl.realtime;
        const stored = new Response(upstream.clone().body, {
          status: 200,
          headers: {
            'Content-Type': upstream.headers.get('Content-Type') || 'application/json',
            'Cache-Control': `max-age=${ttl}`,
          },
        });
        ctx.waitUntil(Promise.resolve().then(() => cache.put(cacheKey, stored)).catch(() => {}));
      }
      record(env, 'miss');
      return clientResponse(upstream, 'MISS');
    } catch (_) {
      return errorResponse(502, 'Upstream unavailable');
    }
  },
};

// L'application demande les horaires à la seconde près. Sans normalisation,
// deux clients d'une même minute produisent deux URL distinctes et le cache
// partagé ne sert jamais. Le remplacement est textuel afin de laisser intact
// l'encodage des autres paramètres (type[] notamment).
function normalizeSearch(search) {
  return search.replace(/([?&](?:from_)?datetime=\d{8}T\d{4})\d{2}(?=&|$)/g, '$100');
}

function sharedCache() {
  return typeof caches !== 'undefined' && caches.default ? caches.default : null;
}

function clientResponse(source, state) {
  const headers = new Headers(cors);
  headers.set('Content-Type', source.headers.get('Content-Type') || 'application/json');
  // Le partage a lieu dans le proxy : les clients gardent leur propre cadence.
  headers.set('Cache-Control', 'no-store');
  headers.set('X-Cache', state);
  const retry = source.headers.get('Retry-After');
  if (retry) headers.set('Retry-After', retry);
  return new Response(source.body, { status: source.status, headers });
}

async function rateLimitKey(request, secret) {
  if (!secret) throw new Error('Missing API secret');
  const encoder = new TextEncoder();
  // HMAC à clé secrète : les IP ne sont pas conservées et ne peuvent pas être
  // retrouvées par simple énumération d'un hash public. Rotation horaire.
  const key = await crypto.subtle.importKey('raw', encoder.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
  const bytes = await crypto.subtle.sign('HMAC', key,
    encoder.encode(`surlequai-rate-limit:${Math.floor(Date.now() / 3600000)}:${ip}`));
  return Array.from(new Uint8Array(bytes), b => b.toString(16).padStart(2, '0')).join('');
}

// Analytics Engine encaisse une écriture par requête, contrairement à KV dont
// le quota d'écritures et l'absence d'incrément atomique rendaient le compteur
// faux dès quelques dizaines d'utilisateurs. L'absence de binding est tolérée.
function record(env, outcome) {
  try {
    env.STATS?.writeDataPoint?.({ blobs: [outcome], doubles: [1], indexes: ['proxy'] });
  } catch (_) {
    // L'indisponibilité des statistiques n'affecte pas la réponse utilisateur.
  }
}
