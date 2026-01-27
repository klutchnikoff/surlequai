# 🚀 Démarrage Rapide - 5 minutes

Guide ultra-rapide pour déployer le proxy en production.

## Prérequis

- Compte Cloudflare (gratuit) : https://dash.cloudflare.com/sign-up
- Domaine `surlequai.app` configuré sur Cloudflare
- Node.js installé

## Installation en 5 étapes

### 1. Installer Wrangler

```bash
npm install -g wrangler
wrangler login
```

### 2. Créer les KV Namespaces

```bash
cd cloudflare-worker

# Rate limiting
wrangler kv:namespace create "RATE_LIMIT_KV"
# Notez l'ID retourné : { id: "abc123..." }

# Stats
wrangler kv:namespace create "STATS_KV"
# Notez l'ID retourné : { id: "def456..." }
```

### 3. Configurer wrangler.toml

Éditez `wrangler.toml` et remplacez :

```toml
[[kv_namespaces]]
binding = "RATE_LIMIT_KV"
id = "abc123..." # ← Votre ID de l'étape 2

[[kv_namespaces]]
binding = "STATS_KV"
id = "def456..." # ← Votre ID de l'étape 2
```

### 4. Stocker la clé API SNCF

```bash
wrangler secret put NAVITIA_API_KEY
# Collez votre clé API quand demandé
```

### 5. Déployer

```bash
wrangler deploy
```

✅ **C'est fait !**

## Test

```bash
curl https://proxy.surlequai.app/api/coverage/sncf/places?q=Rennes
```

Si vous voyez du JSON avec des gares, c'est bon ! 🎉

## Configuration du domaine

Si l'URL `proxy.surlequai.app` n'existe pas encore :

1. Dashboard Cloudflare → **DNS**
2. Ajouter un record `CNAME` :
   - **Name** : `proxy`
   - **Target** : `surlequai-proxy.workers.dev`
   - **Proxy status** : Proxied (orange)

3. Dashboard Cloudflare → **Workers & Pages** → Votre worker
4. **Settings** → **Triggers** → **Add route**
   - **Route** : `proxy.surlequai.app/api/*`

## Mise à jour de l'app Flutter

Une fois déployé, l'app fonctionnera automatiquement car l'URL est déjà configurée :

```dart
// lib/utils/navitia_config.dart (déjà configuré)
static const String proxyUrl = 'https://proxy.surlequai.app/api';
```

## Troubleshooting

### Erreur : "Namespace not found"

Vous avez oublié de remplacer les IDs dans `wrangler.toml`. Retournez à l'étape 3.

### Erreur : "401 Unauthorized" depuis l'API SNCF

Votre clé API SNCF est invalide. Vérifiez-la sur https://numerique.sncf.com et réessayez l'étape 4.

### Erreur : "Route not found"

Le domaine n'est pas configuré. Suivez la section "Configuration du domaine" ci-dessus.

## Next steps

- Lire le [README complet](./README.md) pour plus de détails
- Lire le [rapport de transparence](./TRANSPARENCY.md) pour comprendre la vie privée
- Tester avec l'app Flutter

## Support

Besoin d'aide ? Créez une issue sur GitHub : https://github.com/[VOTRE_REPO]/surlequai/issues
