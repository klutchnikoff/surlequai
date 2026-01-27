# SurLeQuai - Proxy Cloudflare Worker

Proxy transparent pour l'API SNCF/Navitia utilisé par l'application mobile SurLeQuai.

## 🔒 Transparence et Vie Privée

Ce Worker est conçu avec la transparence et le respect de la vie privée comme priorité absolue :

### ❌ Ce que nous NE faisons PAS
- ❌ **Aucun logging des requêtes** - Nous ne stockons AUCUNE trace des requêtes utilisateur
- ❌ **Aucune donnée personnelle** - Pas de stockage de gares, trajets, ou horaires consultés
- ❌ **Aucun tracking individuel** - Impossible de savoir qui a fait quelle requête
- ❌ **Aucune donnée de localisation** - Les IPs ne sont jamais stockées (uniquement hashées temporairement pour le rate limiting)

### ✅ Ce que nous faisons
- ✅ **Compteur global anonyme** - Un simple nombre total de requêtes (ex: "150 000 requêtes depuis le lancement")
- ✅ **Rate limiting anonyme** - Hash temporaire des IPs (60 secondes) pour éviter les abus, puis suppression automatique
- ✅ **Code open source** - 100% auditable et transparent
- ✅ **Pas de tiers** - Aucune intégration avec des services d'analytics, tracking, ou publicité

## 📊 Données stockées

### KV Namespace: `RATE_LIMIT_KV`
- **Clé** : `rl:{hash_ip_temporaire}` (hash SHA-256 avec salt horaire)
- **Valeur** : Compteur de requêtes (integer)
- **TTL** : 60 secondes (suppression automatique)
- **Réversibilité** : ❌ Impossible de retrouver l'IP d'origine (hash + salt horaire)

### KV Namespace: `STATS_KV`
- **Clé** : `stats:total_requests`
- **Valeur** : Compteur global (integer)
- **Usage** : Afficher "X requêtes traitées" sur la page de stats publique

**Aucune autre donnée n'est stockée.**

## 🚀 Déploiement

### Prérequis

1. Compte Cloudflare (gratuit)
2. Domaine configuré sur Cloudflare (`surlequai.app`)
3. Node.js et npm installés
4. Wrangler CLI installé :

```bash
npm install -g wrangler
```

### Étape 1 : Authentification Cloudflare

```bash
wrangler login
```

### Étape 2 : Créer les KV Namespaces

```bash
# Créer le namespace pour le rate limiting
wrangler kv:namespace create "RATE_LIMIT_KV"

# Créer le namespace pour les stats
wrangler kv:namespace create "STATS_KV"
```

Notez les IDs retournés et remplacez-les dans `wrangler.toml`.

### Étape 3 : Stocker la clé API SNCF

**⚠️ IMPORTANT** : Ne JAMAIS commiter la clé API dans le code !

```bash
wrangler secret put NAVITIA_API_KEY
# Entrez votre clé API SNCF quand demandé
```

### Étape 4 : Déployer le Worker

```bash
wrangler deploy
```

### Étape 5 : Configurer le domaine

Dans le dashboard Cloudflare :
1. Allez dans **Workers & Pages**
2. Sélectionnez votre Worker `surlequai-proxy`
3. Allez dans **Settings** > **Triggers**
4. Ajoutez une route : `proxy.surlequai.app/api/*`

### Étape 6 : Tester

```bash
curl https://proxy.surlequai.app/api/coverage/sncf/places?q=Rennes
```

Vous devriez recevoir une réponse JSON de l'API SNCF.

## 📝 Mise à jour du code de l'app

Une fois le Worker déployé, mettez à jour l'URL du proxy dans l'app Flutter :

```dart
// lib/utils/navitia_config.dart
static const String proxyUrl = 'https://proxy.surlequai.app/api';
```

## 🔧 Maintenance

### Voir les logs (sans données personnelles)

```bash
wrangler tail
```

Les logs ne contiennent que :
- Erreurs génériques (pas de détails de requête)
- Statut HTTP des réponses

### Voir les stats globales

```bash
wrangler kv:key get "stats:total_requests" --namespace-id=VOTRE_STATS_KV_ID
```

### Mettre à jour le Worker

Après modification du code :

```bash
wrangler deploy
```

## 💰 Coûts

**Workers Free Tier :**
- 100 000 requêtes / jour
- 10 ms CPU time / requête
- Largement suffisant pour une app en phase de lancement

**Si dépassement :**
- Workers Paid : $5/mois pour 10 millions de requêtes
- KV : $0.50/million de lectures (très peu utilisé ici)

**Estimation pour 1000 utilisateurs actifs/jour :**
- ~50 000 requêtes/jour (50 requêtes/utilisateur)
- ✅ Reste dans le Free Tier

## 🔐 Sécurité

### Rate Limiting
- 100 requêtes/minute par IP
- Hash temporaire (60s) pour éviter les abus
- Pas de stockage permanent des IPs

### Protection contre les abus
- Le Worker refuse les requêtes trop volumineuses
- CORS configuré pour accepter uniquement les requêtes de l'app
- Pas de requêtes POST/PUT/DELETE (lecture seule)

### Rotation de la clé API
Si vous devez changer la clé API SNCF :

```bash
wrangler secret put NAVITIA_API_KEY
# Entrez la nouvelle clé
```

Effet immédiat, pas besoin de redéployer.

## 📚 Documentation API

Le Worker est un proxy transparent. Toutes les routes de l'API Navitia sont accessibles :

```
https://proxy.surlequai.app/api/coverage/sncf/places?q=...
https://proxy.surlequai.app/api/coverage/sncf/journeys?from=...&to=...
https://proxy.surlequai.app/api/coverage/sncf/stop_areas/.../departures
```

Voir la doc officielle : https://doc.navitia.io/

## 🤝 Contributions

Le code de ce Worker est public et auditable. N'hésitez pas à :
- Auditer le code pour vérifier qu'il respecte bien la vie privée
- Proposer des améliorations
- Signaler des problèmes de sécurité

## 📄 Licence

MIT - Voir LICENSE

## ⚖️ Mentions légales

**Hébergement** : Cloudflare Workers (infrastructure mondiale)

**Données personnelles** :
- Aucune donnée personnelle n'est collectée ou stockée
- Pas de cookies, pas de tracking, pas d'analytics
- Les IPs sont hashées temporairement (60s) pour le rate limiting puis supprimées
- Conforme RGPD par design (privacy by design)

**Responsable du traitement** : [Votre nom/entreprise]

**Contact** : [Votre email]

Pour toute question sur la vie privée ou la transparence de ce service, n'hésitez pas à nous contacter.
