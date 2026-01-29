# Release Notes - v0.11.0

**Date** : 29 janvier 2026
**Build** : 0.11.0+3
**Commits** : 31 depuis v0.10.0

---

## 🎯 Highlights

- ✅ **Google Play Store compliance** : Prêt pour publication
- 🏗️ **Architecture refactoring** : Migration Freezed + ViewModel pattern
- ⚡ **Performance** : Optimisations widget updates avec throttling
- 🧪 **Tests** : Suite de tests unitaires complète
- 📱 **UI/UX** : Améliorations interface utilisateur

---

## 🆕 Fonctionnalités

### Google Play Store Compliance
- Ajout disclaimers "Application non officielle" (in-app + store listing)
- Liens précis vers sources officielles :
  - API Navitia : https://api.sncf.com
  - Documentation : https://doc.navitia.io
  - Portail développeur : https://numerique.sncf.com
- Conformité politique "Misleading Claims"

### UI/UX
- Boutons radio thème affichés verticalement (meilleure lisibilité mobile)
- Correction directions inversées dans modal horaires
- Amélioration affichage numéro de voie
- Image de prévisualisation du widget ajoutée

### Documentation
- Politique de confidentialité complète
- GitHub Pages configuré
- README amélioré avec screenshots
- Mentions légales dans l'app

---

## 🏗️ Refactoring Architectural

### Migration Freezed
- **Tous les modèles domain** migrés vers Freezed
  - Immutabilité garantie
  - JSON serialization type-safe
  - `copyWith` automatique
- **DTOs Navitia** avec unions types pour gestion erreurs
- Tests unitaires exhaustifs des modèles

### DirectionCardViewModel (Pattern Shared Logic)
- **Logique UI centralisée** pour app + widgets natifs
- Sealed class avec pattern matching exhaustif
- **Testable** avec injection de temps
- Zero duplication de code

### ApiService Refactoring
- Centralisation de toute la logique HTTP
- Gestion unifiée des erreurs (SocketException, TimeoutException, etc.)
- Support BYOK (Bring Your Own Key)
- Cache service-day aware
- Tests unitaires avec mock HTTP

### WidgetService
- Logique unifiée pour iOS/Android
- Utilise DirectionCardViewModel (shared logic)
- Tests avec mock Platform Channels

---

## ⚡ Performance

### Widget Updates Throttling
- Cooldown de 5 minutes entre updates widgets
- Réduit drastiquement les appels API en background
- Optimisation batterie et data
- Force refresh disponible (pull-to-refresh)

### Gestion Cache
- Détection et récupération cache corrompu
- Cache par service-day (pas de refresh inutiles)
- Offline-first avec fallback gracieux

---

## 🧪 Tests

### Suite de Tests Unitaires Ajoutée
- ✅ `ApiService` - Tests HTTP avec mocks
- ✅ `WidgetService` - Tests Platform Channels
- ✅ `DirectionCardViewModel` - Tests logique métier
- ✅ `TripSorter` - Tests tri trajets
- ✅ `Navitia DTOs` - Tests parsing JSON
- ✅ `TripProvider` - Tests orchestration (basique)

**Couverture estimée** : ~45-50% (fonctionnel)

---

## 🔧 Correctifs

### Critiques
- Migration APIs dépréciées Flutter 3.32+ :
  - `Radio.groupValue` → `RadioGroup`
  - `Color.withOpacity()` → `Color.withValues()`
- Debug flags sécurisés (fromEnvironment, défaut: false)
- Permissions réseau Android corrigées
- Secure storage Android fixé

### Mineurs
- Extension fichier PNG manquante corrigée
- Dépendances .env supprimées
- `const` invalides sur exceptions supprimés
- `flutter_native_splash` déplacé vers dependencies

---

## 📁 Organisation Projet

### Structure Assets Réorganisée
```
assets/           ← Embarqués dans l'app
docs/assets/      ← Documentation GitHub
store-assets/     ← Play Store/App Store
```

### Documentation
- 3 fichiers README ajoutés (assets/, docs/assets/, store-assets/)
- Screenshots renommés avec noms explicites
- TimetableService marqué pour refactoring v1.1

---

## 🔐 Sécurité

- Configuration signature Android pour release
- Clés API jamais en dur (proxy Cloudflare ou BYOK)
- Politique de confidentialité publiée
- Aucune donnée collectée

---

## 📦 Build & Compatibilité

- **Version** : 0.11.0+3
- **Flutter** : 3.x compatible
- **Minimum SDK** : Android (voir build.gradle)
- **Plateformes** : iOS, Android

---

## 🚀 Déploiement

### Play Store
- ✅ Description conforme aux politiques
- ✅ Disclaimers présents
- ✅ Sources officielles citées
- ✅ Icône 512x512 disponible
- ⏳ En attente validation

---

## 🙏 Crédits

**Développeur** : Nicolas Klutchnikoff
**IAg** : Claude Sonnet 4.5 (Anthropic)
**Licence** : MIT
**Données** : SNCF Open Data (Licence Ouverte Etalab 2.0)

---

## 📊 Statistiques

- **31 commits** depuis v0.10.0
- **~5,326 lignes** de code production
- **~677 lignes** de tests
- **12 fichiers** d'assets réorganisés
- **6 services** refactorisés

---

## 🔮 Roadmap v1.x

**Prévu pour v1.0** :
- Augmentation couverture tests (70%+)
- Suppression TimetableService (migration vers StorageService)
- Informations de trafic (perturbations)

**Future** :
- Accessibilité (WCAG 2.1)
- Shake to refresh, améliorations UI

---

**Merci d'utiliser SurLeQuai !** ❤️
