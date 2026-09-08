# Proxy SurLeQuai

Ce Worker ajoute la clé SNCF aux requêtes de l'application. Il accepte `GET` et
`OPTIONS` sur les ressources `coverage/sncf/journeys`, `places` et
`stop_areas/{id}/departures`. Le préfixe historique `/api` reste accepté.

Les seuls en-têtes envoyés à SNCF sont `Authorization` et `Accept`. Le Worker ne
transmet pas les cookies, l'autorisation du client ou ses en-têtes d'adresse IP.
Les redirections amont sont refusées et la requête expire après neuf secondes.
CORS autorise les origines web ; ce mécanisme ne réserve pas le proxy à l'app.

## Protection et données

Le binding natif `RATE_LIMITER` limite à 100 requêtes par période de 60 secondes
et par clé. La clé est un HMAC de l'IP avec le secret API et une rotation horaire.
Il s'agit d'une protection approximative locale au point de présence Cloudflare,
pas d'un quota global strict. Une panne du limiteur produit une réponse 503 ;
un dépassement produit une réponse 429 avec `Retry-After: 60`.

`STATS_KV` ne contient que `stats:total_requests`, un compteur global indicatif
(non atomique). Le Worker ne stocke pas les trajets ni les IP en clair dans KV.
Voir [TRANSPARENCY.md](TRANSPARENCY.md) pour le périmètre exact de ces garanties.

## Vérification locale

Avec Node.js 22 ou ultérieur, sans dépendance ni secret :

```sh
npm test
```

Les tests couvrent les routes, les en-têtes amont, la limitation et les erreurs.

## Déploiement

Le déploiement est une opération distincte des modifications de l'application.

1. Vérifier le compte Cloudflare et le nom du Worker dans `wrangler.toml`.
2. Vérifier que `namespace_id = "1001"` du limiteur est réservé à ce Worker.
3. Renseigner l'ID de `STATS_KV` correspondant à ce compte.
4. Configurer le secret avec `npx wrangler secret put NAVITIA_API_KEY`.
5. Déployer avec `npx wrangler deploy` et vérifier le domaine configuré.

L'ancien binding `RATE_LIMIT_KV` n'est plus utilisé. Le namespace existant peut
être supprimé après vérification qu'aucun autre Worker ne l'utilise.

Documentation du [limiteur natif Cloudflare](https://developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/).
