# 🔍 Rapport de Transparence - SurLeQuai Proxy

**Dernière mise à jour** : 27 janvier 2026
**Version du Worker** : 1.0.0

## 🎯 Notre Engagement

SurLeQuai est une application qui respecte votre vie privée. Ce document explique en détail ce que fait notre proxy API et ce qu'il ne fait **pas**.

## 📊 Ce que nous collectons

### Données techniques (anonymes)

1. **Compteur global de requêtes**
   - Un simple nombre : "X requêtes traitées depuis le lancement"
   - Pas de détail sur qui, quoi, quand
   - Affiché publiquement sur cette page

2. **Hash temporaire d'IP (rate limiting)**
   - Durée de vie : 60 secondes maximum
   - But : Empêcher les abus (trop de requêtes)
   - Technique : Hash SHA-256 avec salt horaire (non-réversible)
   - Suppression automatique après 60 secondes
   - ❌ Impossible de retrouver l'IP d'origine

### Ce que nous ne collectons PAS

- ❌ Aucune adresse IP stockée en clair
- ❌ Aucun trajet consulté
- ❌ Aucune gare de départ ou d'arrivée
- ❌ Aucun horaire consulté
- ❌ Aucun identifiant d'appareil
- ❌ Aucun cookie ou session
- ❌ Aucun log de requête

## 🔒 Comment ça marche

```
1. Votre téléphone → "Quels sont les trains Rennes-Nantes ?"
2. Notre proxy → Ajoute la clé API
3. API SNCF → Répond avec les horaires
4. Notre proxy → Vous retourne la réponse
5. ❌ Rien n'est stocké
```

Le proxy est un **simple intermédiaire technique**. Il ne lit pas, n'analyse pas, et ne stocke pas vos requêtes.

## 🧪 Vérification indépendante

### Code source

Le code complet du proxy est disponible publiquement :
- **Dépôt GitHub** : https://github.com/[VOTRE_REPO]/surlequai
- **Fichier Worker** : `cloudflare-worker/worker.js`

Toute personne avec des compétences techniques peut :
- Lire le code
- Vérifier qu'il ne fait pas de tracking
- Auditer les appels réseau
- Proposer des améliorations

### Test de transparence

Pour vérifier que nous ne loggons rien :

1. **Inspectez le code** : Cherchez les mots-clés `console.log`, `fetch` vers des services tiers, `localStorage`, `cookie`. Vous n'en trouverez aucun pour le tracking.

2. **Analysez le trafic réseau** :
   ```bash
   # Le Worker ne fait qu'un seul appel réseau : vers l'API SNCF
   curl -v https://proxy.surlequai.app/api/coverage/sncf/places?q=Paris
   ```

3. **Inspectez les KV namespaces** :
   ```bash
   # Seules 2 namespaces existent :
   # 1. RATE_LIMIT_KV : hash temporaires (60s)
   # 2. STATS_KV : compteur global (1 clé)
   ```

## 📈 Statistiques publiques

### Compteur global

Nombre total de requêtes traitées depuis le lancement : **[À afficher dynamiquement]**

C'est la SEULE métrique que nous collectons.

### Transparence du rate limiting

- **Limite** : 100 requêtes/minute par IP
- **Fenêtre** : 60 secondes glissantes
- **Stockage** : Hash non-réversible avec TTL automatique
- **Objectif** : Éviter les abus et protéger l'API SNCF

Si vous dépassez cette limite, vous recevrez une erreur `429 Too Many Requests` et devrez attendre 60 secondes. C'est une protection technique, pas du tracking.

## 🌍 Hébergement

- **Fournisseur** : Cloudflare Workers
- **Localisation** : Réseau mondial (edge computing)
- **Conformité** : RGPD, privacy by design

Cloudflare Workers exécute le code à la frontière du réseau (edge), au plus près de vous. Les données ne passent jamais par nos serveurs car **nous n'avons pas de serveurs**.

## 🔐 Sécurité

### Protection des données

1. **HTTPS obligatoire** - Toutes les communications sont chiffrées
2. **Pas de base de données** - Impossible de subir un leak de données qu'on ne stocke pas
3. **Clé API sécurisée** - Stockée dans les secrets Cloudflare (chiffrée)
4. **Rate limiting** - Protection contre les abus

### Audits de sécurité

Si vous êtes un chercheur en sécurité et trouvez une faille, contactez-nous à : [VOTRE EMAIL]

Nous ne pouvons pas offrir de bug bounty pour l'instant (projet open source bénévole), mais votre contribution sera créditée et appréciée.

## 🤔 Questions fréquentes

### Pourquoi utiliser un proxy ?

L'API SNCF nécessite une clé API qui doit rester secrète. Sans proxy, nous devrions :
- Soit exposer la clé dans le code de l'app (danger de vol)
- Soit forcer chaque utilisateur à créer sa propre clé (friction)

Le proxy permet d'utiliser une clé partagée sans l'exposer.

### Alternative : BYOK (Bring Your Own Key)

Si vous ne faites pas confiance au proxy (ce qui est légitime !), vous pouvez :
1. Créer votre propre clé API sur https://numerique.sncf.com
2. L'entrer dans les paramètres de l'app
3. L'app appellera directement l'API SNCF, **sans passer par notre proxy**

Cette option est disponible dans **Paramètres > Avancé > Clé API personnalisée (BYOK)**.

### Pourquoi ne pas utiliser Google Analytics ?

Parce que Google Analytics collecte des tonnes de données sur vous, et nous ne voulons pas ça.

Notre philosophie : **une seule chose, mais bien faite**. On affiche des horaires de trains, point. Pas besoin de savoir qui vous êtes, où vous allez, ou combien de fois vous ouvrez l'app.

### Comment financer le service ?

- Le proxy coûte ~$0 en phase de lancement (Free Tier Cloudflare : 100k requêtes/jour)
- Si ça décolle : $5/mois pour 10 millions de requêtes
- Pas de publicité, pas de vente de données, pas de freemium

Le projet est **open source** et **bénévole** pour l'instant.

## 📧 Contact

**Questions sur la vie privée** : [VOTRE EMAIL]
**Signaler un problème de sécurité** : [VOTRE EMAIL]
**Code source** : https://github.com/[VOTRE_REPO]/surlequai

## 📜 Historique des modifications

### Version 1.0.0 (27 janvier 2026)
- Lancement initial du proxy
- ZERO logging des données utilisateur
- Rate limiting anonyme
- Compteur global anonyme

---

**Dernière vérification** : 27 janvier 2026
**Prochaine audit prévu** : 27 avril 2026

*Ce document sera mis à jour à chaque changement du Worker. Les changements seront visibles dans l'historique Git.*
