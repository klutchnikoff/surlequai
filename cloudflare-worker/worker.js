/**
 * SurLeQuai Cloudflare Worker - Proxy API SNCF
 *
 * Ce Worker sert de proxy transparent entre l'application mobile SurLeQuai
 * et l'API Navitia (SNCF). Il ajoute automatiquement la clé API SNCF aux
 * requêtes pour éviter d'exposer la clé dans le code de l'application.
 *
 * TRANSPARENCE ET VIE PRIVÉE :
 * - ❌ AUCUN logging des requêtes utilisateur
 * - ❌ AUCUNE donnée personnelle stockée
 * - ✅ Compteurs globaux anonymes uniquement (nombre total de requêtes)
 * - ✅ Rate limiting basique sans identification individuelle
 * - ✅ Code source public et auditable
 *
 * @version 1.0.0
 * @license MIT
 */

// Configuration
const NAVITIA_API_URL = 'https://api.sncf.com/v1';
const RATE_LIMIT_MAX = 100; // Requêtes max par IP par minute
const RATE_LIMIT_WINDOW = 60000; // Fenêtre de 60 secondes

/**
 * Point d'entrée principal du Worker
 */
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request));
});

/**
 * Gère une requête entrante
 *
 * @param {Request} request - Requête HTTP entrante
 * @returns {Promise<Response>} - Réponse HTTP
 */
async function handleRequest(request) {
  // CORS preflight
  if (request.method === 'OPTIONS') {
    return handleCORS();
  }

  try {
    // Vérification du rate limiting (sans stocker d'identifiant personnel)
    const rateLimitResponse = await checkRateLimit(request);
    if (rateLimitResponse) {
      return rateLimitResponse;
    }

    // Extraire le chemin de l'API depuis l'URL de la requête
    const url = new URL(request.url);
    const apiPath = url.pathname.replace('/api/', '');
    const queryString = url.search;

    // Construire l'URL complète vers l'API Navitia
    const navitiaUrl = `${NAVITIA_API_URL}/${apiPath}${queryString}`;

    // Créer les headers avec authentification
    const headers = new Headers(request.headers);
    headers.set('Authorization', `Basic ${btoa(NAVITIA_API_KEY + ':')}`);
    headers.delete('host'); // Supprimer le host d'origine

    // Transférer la requête à l'API Navitia
    const navitiaResponse = await fetch(navitiaUrl, {
      method: request.method,
      headers: headers,
      body: request.method !== 'GET' ? request.body : undefined,
    });

    // Créer la réponse avec les headers CORS
    const response = new Response(navitiaResponse.body, {
      status: navitiaResponse.status,
      statusText: navitiaResponse.statusText,
      headers: navitiaResponse.headers,
    });

    // Ajouter les headers CORS
    response.headers.set('Access-Control-Allow-Origin', '*');
    response.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    response.headers.set('Access-Control-Allow-Headers', 'Content-Type');

    // ✅ Incrémenter le compteur global ANONYME (pas de tracking individuel)
    await incrementGlobalCounter();

    return response;

  } catch (error) {
    // En cas d'erreur, retourner une erreur générique
    // ❌ NE PAS logger l'erreur avec des détails de requête
    return new Response(
      JSON.stringify({ error: 'Proxy error', message: error.message }),
      {
        status: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      }
    );
  }
}

/**
 * Gère les requêtes CORS preflight
 *
 * @returns {Response} - Réponse CORS
 */
function handleCORS() {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type',
      'Access-Control-Max-Age': '86400', // 24 heures
    },
  });
}

/**
 * Vérifie le rate limiting de manière ANONYME
 *
 * ⚠️ IMPORTANT : Cette fonction NE STOCKE PAS les IPs individuelles.
 * Elle utilise uniquement un hash non-réversible pour le rate limiting.
 *
 * @param {Request} request - Requête HTTP
 * @returns {Promise<Response|null>} - Response si rate limit dépassé, null sinon
 */
async function checkRateLimit(request) {
  // Pour éviter de stocker les IPs, on utilise un hash non-réversible
  // avec un salt qui change toutes les heures
  const ip = request.headers.get('CF-Connecting-IP') || 'unknown';
  const hourSalt = Math.floor(Date.now() / 3600000); // Change chaque heure
  const ipHash = await hashString(`${ip}-${hourSalt}`);

  // Utiliser KV pour stocker les compteurs (avec TTL automatique)
  // Note : RATE_LIMIT_KV doit être configuré dans wrangler.toml
  try {
    const key = `rl:${ipHash}`;
    const count = await RATE_LIMIT_KV.get(key);
    const currentCount = count ? parseInt(count) : 0;

    if (currentCount >= RATE_LIMIT_MAX) {
      return new Response(
        JSON.stringify({
          error: 'Rate limit exceeded',
          message: 'Too many requests, please try again later',
        }),
        {
          status: 429,
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Retry-After': '60',
          },
        }
      );
    }

    // Incrémenter le compteur avec TTL de 60 secondes
    await RATE_LIMIT_KV.put(key, (currentCount + 1).toString(), {
      expirationTtl: 60,
    });

  } catch (error) {
    // Si KV n'est pas disponible, laisser passer (fail open)
    // ❌ NE PAS logger l'erreur avec l'IP
  }

  return null;
}

/**
 * Hash une chaîne de caractères (SHA-256)
 *
 * @param {string} str - Chaîne à hasher
 * @returns {Promise<string>} - Hash hexadécimal
 */
async function hashString(str) {
  const encoder = new TextEncoder();
  const data = encoder.encode(str);
  const hashBuffer = await crypto.subtle.digest('SHA-256', data);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
}

/**
 * Incrémente un compteur global ANONYME
 *
 * ✅ Ce compteur est complètement anonyme - il compte juste le nombre
 * total de requêtes sans aucune information sur qui les fait.
 */
async function incrementGlobalCounter() {
  try {
    const key = 'stats:total_requests';
    const count = await STATS_KV.get(key);
    const newCount = count ? parseInt(count) + 1 : 1;
    await STATS_KV.put(key, newCount.toString());
  } catch (error) {
    // Ignorer les erreurs de stats (non-bloquant)
  }
}
