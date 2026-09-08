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

Le binding `STATS` (Analytics Engine) compte les réponses amont, en distinguant
seulement les succès du cache des appels réellement transmis à SNCF. Il remplace
le compteur `STATS_KV`, dont le quota d'écritures et l'absence d'incrément
atomique faussaient le total dès quelques dizaines d'utilisateurs.
Voir [TRANSPARENCY.md](TRANSPARENCY.md) pour le périmètre exact de ces garanties.

## Cache partagé

Les horaires d'une gare sont identiques pour tous ceux qui la consultent : les
réponses amont sont donc mises en cache et partagées. L'application demandant
les horaires à la seconde près, le Worker tronque `datetime` et `from_datetime`
à la minute avant d'appeler SNCF, sans quoi deux clients d'une même minute
produiraient deux URL distinctes et le cache ne servirait jamais.

Les horaires sont conservés 60 secondes, la recherche de gares 86 400 secondes.
Seules les réponses `200` sont mises en cache, afin qu'une erreur amont ne soit
pas resservie à tous. Le cache est local à chaque point de présence Cloudflare :
le partage est réel mais partiel. L'en-tête `X-Cache` vaut `HIT` ou `MISS`, et
les clients continuent de recevoir `Cache-Control: no-store` pour garder leur
propre cadence de rafraîchissement. Une panne du cache n'interrompt pas le
service : la requête part alors vers SNCF.

## Vérification locale

Avec Node.js 22 ou ultérieur, sans dépendance ni secret :

```sh
npm test
```

Les tests couvrent les routes, les en-têtes amont, la limitation, les erreurs,
la normalisation à la minute et le partage des réponses par le cache.

## Déploiement

Le déploiement est une opération distincte des modifications de l'application.

1. Vérifier le compte Cloudflare et le nom du Worker dans `wrangler.toml`.
2. Vérifier que `namespace_id = "1001"` du limiteur est réservé à ce Worker.
3. Vérifier que le jeu de données Analytics Engine `surlequai_requests` est
   accessible sur ce compte.
4. Configurer le secret avec `npx wrangler secret put NAVITIA_API_KEY`.
5. Déployer avec `npx wrangler deploy` et vérifier le domaine configuré.

Les anciens bindings `RATE_LIMIT_KV` et `STATS_KV` ne sont plus utilisés. Les
namespaces existants peuvent être supprimés après vérification qu'aucun autre
Worker ne les utilise.

Documentation du [limiteur natif Cloudflare](https://developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/).
