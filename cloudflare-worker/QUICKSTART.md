# 🚀 Démarrage Rapide - 5 minutes

Guide ultra-rapide pour déployer le proxy en production.

## Prérequis

- Compte Cloudflare (gratuit) : https://dash.cloudflare.com/sign-up
- Domaine `surlequai.app` configuré sur Cloudflare
- Node.js installé

## Installation en 3 étapes

Aucun KV Namespace n'est nécessaire : le limiteur est natif et les statistiques
passent par Analytics Engine, dont le jeu de données est créé à la première
écriture.

### 1. Installer Wrangler

```bash
npm install -g wrangler
wrangler login
```

### 2. Stocker la clé API SNCF

```bash
wrangler secret put NAVITIA_API_KEY
# Collez votre clé API quand demandé
```

### 3. Déployer

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

### Erreur : "401 Unauthorized" depuis l'API SNCF

Votre clé API SNCF est invalide. Vérifiez-la sur https://numerique.sncf.com et réessayez l'étape 2.

### Erreur : "Route not found"

Le domaine n'est pas configuré. Suivez la section "Configuration du domaine" ci-dessus.

## Next steps

- Lire le [README complet](./README.md) pour plus de détails
- Lire le [rapport de transparence](./TRANSPARENCY.md) pour comprendre la vie privée
- Tester avec l'app Flutter

## Support

Besoin d'aide ? Créez une issue sur GitHub : https://github.com/[VOTRE_REPO]/surlequai/issues
