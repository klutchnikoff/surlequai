/** Proxy SNCF : aucun en-tête utilisateur n'est transmis à l'amont. */
const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

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
    if (!/^\/coverage\/sncf\/(journeys|places|stop_areas\/[^/]+\/departures)$/.test(path)) {
      return errorResponse(404, 'Unknown endpoint');
    }
    try {
      const key = await rateLimitKey(request, env.NAVITIA_API_KEY);
      const { success } = await env.RATE_LIMITER.limit({ key });
      if (!success) return errorResponse(429, 'Too many requests', { 'Retry-After': '60' });
    } catch (_) {
      return errorResponse(503, 'Rate limiter unavailable', { 'Retry-After': '60' });
    }
    try {
      const upstream = await fetch(`https://api.sncf.com/v1${path}${url.search}`, {
        method: 'GET',
        headers: {
          Authorization: `Basic ${btoa(env.NAVITIA_API_KEY + ':')}`,
          Accept: 'application/json',
        },
        redirect: 'error',
        signal: AbortSignal.timeout(9000),
      });
      const headers = new Headers(cors);
      headers.set('Content-Type', upstream.headers.get('Content-Type') || 'application/json');
      headers.set('Cache-Control', 'no-store');
      const retry = upstream.headers.get('Retry-After');
      if (retry) headers.set('Retry-After', retry);
      // Compteur indicatif : KV ne fournit pas d'incrément atomique.
      ctx.waitUntil(incrementGlobalCounter(env));
      return new Response(upstream.body, { status: upstream.status, headers });
    } catch (_) {
      return errorResponse(502, 'Upstream unavailable');
    }
  },
};

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

async function incrementGlobalCounter(env) {
  try {
    const previous = Number(await env.STATS_KV.get('stats:total_requests')) || 0;
    await env.STATS_KV.put('stats:total_requests', String(previous + 1));
  } catch (_) {
    // L'indisponibilité des statistiques n'affecte pas la réponse utilisateur.
  }
}
