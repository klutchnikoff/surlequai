# Instructions pour Claude Code - Projet SurLeQuai

**Date** : 23 janvier 2026
**Projet** : SurLeQuai - Application Flutter pour horaires TER
**Développeur principal** : Nicolas

---

## 📚 Documents de référence OBLIGATOIRES

**AVANT TOUTE ACTION, LIRE ATTENTIVEMENT :**

1. **`docs/FONCTIONNALITES.md`** - Spécifications techniques complètes v1.0
   - Toutes les fonctionnalités à implémenter
   - Interface utilisateur détaillée
   - Architecture des données
   - Checklist de validation

2. **`docs/PROJET.md`** - Vision globale et contexte
   - Philosophie du projet
   - Identité visuelle
   - Stratégie de distribution

---

## 🎯 Philosophie du projet

### Principe fondamental
**"Une seule chose, mais bien faite"**

- Simplicité MAXIMALE à chaque décision
- Lisibilité avant tout
- Pas de feature superflue
- Design minimaliste et épuré

### Priorités absolues

1. **Lisibilité** : Info visible d'un coup d'œil
2. **Rapidité** : Affichage instantané (< 200ms)
3. **Fiabilité** : Fonctionne hors-ligne
4. **Simplicité** : Zéro friction utilisateur

### Ce qu'on NE fait PAS

❌ Fonctionnalités "nice to have" non documentées
❌ Animations complexes ou tape-à-l'œil
❌ Dépendances inutiles
❌ Abstraction excessive
❌ Over-engineering

---

## 🏗️ Architecture Flutter

### Structure de dossiers STRICTE

```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données (immutables)
│   ├── station.dart
│   ├── trip.dart
│   ├── departure.dart
│   └── timetable.dart
├── services/                    # Logique métier
│   ├── api_service.dart         # Appels API SNCF
│   ├── storage_service.dart     # SQLite + SharedPreferences
│   ├── timetable_service.dart   # Gestion cache horaires
│   └── realtime_service.dart    # Temps réel
├── screens/                     # Écrans complets
│   ├── home_screen.dart         # Dashboard principal
│   ├── settings_screen.dart     # Paramètres
│   └── station_picker_screen.dart
├── widgets/                     # Composants réutilisables
│   ├── direction_card.dart      # Carte A→B ou B→A
│   ├── train_info.dart          # Info d'un train
│   ├── status_banner.dart       # Bandeau hors-connexion
│   ├── drawer_trips.dart        # Drawer multi-trajets
│   └── schedules_modal.dart     # Modal tous horaires
├── theme/                       # Design system
│   ├── app_theme.dart           # Thème clair/sombre
│   ├── colors.dart              # Palette de couleurs
│   └── text_styles.dart         # Styles de texte
└── utils/                       # Utilitaires
    ├── constants.dart           # Constantes
    ├── date_helpers.dart        # Manipulation dates
    └── formatters.dart          # Formatage affichage
```

### Dépendances autorisées (pubspec.yaml)

**State management** :
- `provider: ^6.1.1` (préféré pour la simplicité)
- OU `riverpod: ^2.4.0` (si besoin de features avancées)

**Stockage** :
- `sqflite: ^2.3.0` - Base de données locale
- `shared_preferences: ^2.2.2` - Préférences simples
- `path_provider: ^2.1.1` - Chemins système

**Network** :
- `http: ^1.1.0` - Requêtes HTTP simples

**UI** :
- `pull_to_refresh: ^2.0.0` - Pull-to-refresh natif

**Utilitaires** :
- `intl: ^0.19.0` - Internationalisation et dates
- `uuid: ^4.2.0` - Génération d'IDs

**PAS DE** :
- Librairies d'animations complexes
- UI frameworks tiers (tout en Material/Cupertino natif)
- ORM lourd
- GraphQL, Firebase, etc.

---

## 💾 Gestion des données

### Règles de stockage

**SQLite (horaires théoriques)** :
```dart
// Tables minimales, indexées
// Pas de relations complexes
// Requêtes optimisées avec index
```

**SharedPreferences (settings + trajets favoris)** :
```dart
// JSON simple
// Pas de structures imbriquées profondes
// Toujours avec valeurs par défaut
```

**Cache mémoire (temps réel)** :
```dart
// Durée de vie : 60 secondes
// Pas de persistance
// Invalidation automatique
```

### Flux de données OBLIGATOIRE

```
1. Au lancement → Afficher cache local (< 200ms)
2. En parallèle → Vérifier réseau
3. Si réseau OK → Récupérer temps réel
4. Mettre à jour UI avec transition douce
5. Si pas de réseau → Rester sur cache + bandeau bleu
```

---

## 🎨 Interface utilisateur

### Design System

**Couleurs (à utiliser EXACTEMENT)** :

```dart
// États des trains
static const onTime = Color(0xFF22C55E);      // Vert
static const delayed = Color(0xFFF59E0B);     // Orange
static const canceled = Color(0xFFEF4444);    // Rouge
static const offline = Color(0xFF60A5FA);     // Bleu pâle
static const secondary = Color(0xFF9CA3AF);   // Gris

// Modes
static const bgLight = Color(0xFFFFFFFF);
static const bgDark = Color(0xFF1F2937);
static const textLight = Color(0xFF111827);
static const textDark = Color(0xFFF9FAFB);
```

**Tailles de texte (à respecter)** :

```dart
// Heure prochain train
static const hugeText = 56.0;

// Voie
static const largeText = 28.0;

// État (À l'heure, +5 min, etc.)
static const mediumText = 24.0;

// Horaires suivants
static const smallText = 18.0;

// Textes secondaires
static const tinyText = 14.0;
```

### Espacements

```dart
// Utiliser un système de grille 8px
static const spacing1 = 8.0;   // Petit
static const spacing2 = 16.0;  // Moyen
static const spacing3 = 24.0;  // Grand
static const spacing4 = 32.0;  // Très grand
```

### Animations

**Durées standardisées** :
- Transition rapide : 150ms
- Transition normale : 300ms
- Transition lente : 500ms

**Courbes** :
- `Curves.easeInOut` par défaut
- Jamais de courbes "bouncey" ou exagérées

---

## 🔧 Bonnes pratiques de code

### Nommage

```dart
// Classes : PascalCase
class TrainDeparture { }

// Fichiers : snake_case
train_departure.dart

// Variables/fonctions : camelCase
final nextTrain = ...;
void fetchDepartures() { }

// Constantes : lowerCamelCase (pas SCREAMING_CASE)
static const primaryColor = ...;
```

### Structure d'un Widget

```dart
class DirectionCard extends StatelessWidget {
  // 1. Propriétés (final)
  final String from;
  final String to;
  final List<Departure> departures;

  // 2. Constructeur (const si possible)
  const DirectionCard({
    Key? key,
    required this.from,
    required this.to,
    required this.departures,
  }) : super(key: key);

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container(
      // ...
    );
  }

  // 4. Méthodes privées helper (si nécessaire)
  Widget _buildHeader() {
    // ...
  }
}
```

### Gestion d'erreur

```dart
// TOUJOURS wrapper les appels réseau
try {
  final data = await apiService.fetchDepartures();
  // ...
} on SocketException {
  // Pas de réseau → mode offline
  _showOfflineBanner();
} on TimeoutException {
  // Timeout → retry
  _retryWithBackoff();
} catch (e) {
  // Erreur inconnue → log + message générique
  debugPrint('Error: $e');
  _showErrorSnackbar('Impossible de charger les horaires');
}
```

### Performance

```dart
// Utiliser const partout où possible
const Text('Rennes → Nantes');

// Éviter les rebuilds inutiles
class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);
  // ...
}

// Lazy loading pour les listes longues
ListView.builder(
  itemCount: departures.length,
  itemBuilder: (context, index) => ...,
);
```

---

## 🧪 Tests et validation

### Avant de marquer une tâche "terminée"

- [ ] Code compile sans warning
- [ ] `flutter analyze` passe sans erreur
- [ ] Hot reload fonctionne (pas besoin de restart)
- [ ] Testé sur simulateur iOS
- [ ] Testé sur émulateur Android (si applicable)
- [ ] Mode sombre ET clair validés
- [ ] Gestes fonctionnent (swipe, pull-to-refresh, etc.)
- [ ] Mode hors-ligne fonctionne
- [ ] Aucun lag visible (60 FPS)

### Critères de qualité

**Performance** :
- Lancement < 1 seconde
- Rafraîchissement < 500ms
- Scroll fluide (60 FPS)
- Pas de memory leak

**UI** :
- Texte lisible sur tous les fonds
- Espacements cohérents (grille 8px)
- Animations douces (pas saccadées)
- Feedback visuel sur toutes les actions

---

## 🚫 Erreurs courantes à ÉVITER

### Architecture

❌ **Logique métier dans les Widgets**
```dart
// NON
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = http.get('...'); // ❌ API call dans build
    return ...;
  }
}
```

✅ **Logique dans les Services**
```dart
// OUI
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final service = context.watch<ApiService>();
    return ...;
  }
}
```

### State Management

❌ **setState partout**
```dart
// NON pour ce projet
setState(() {
  _data = newData;
});
```

✅ **Provider/Riverpod**
```dart
// OUI
context.read<DataProvider>().updateData(newData);
```

### UI

❌ **Valeurs hardcodées**
```dart
// NON
Container(
  color: Color(0xFF22C55E), // ❌ Hardcoded
  padding: EdgeInsets.all(16), // ❌ Magic number
)
```

✅ **Constantes nommées**
```dart
// OUI
Container(
  color: AppColors.onTime,
  padding: EdgeInsets.all(AppSpacing.medium),
)
```

---

## 🔄 Workflow de développement

### 1. Avant de coder

1. Lire la section concernée dans `docs/FONCTIONNALITES.md`
2. Comprendre le besoin utilisateur
3. Vérifier les contraintes de design
4. Planifier l'approche (ne pas foncer tête baissée)

### 2. Pendant le développement

1. Coder par petits incréments
2. Tester fréquemment (hot reload)
3. Commenter UNIQUEMENT le "pourquoi", pas le "quoi"
4. Respecter la structure de dossiers

### 3. Après le code

1. Relire le code (éliminer le superflu)
2. Vérifier la checklist de tests
3. Formater : `dart format .`
4. Analyser : `flutter analyze`

---

## 📝 Communication avec le développeur

### Quand demander une clarification

- ❓ Ambiguïté dans les specs
- ❓ Trade-off performance vs simplicité
- ❓ Choix de librairie externe
- ❓ Modification de l'architecture proposée

### Format des questions

```
🤔 Question sur [fonctionnalité X]

Contexte : [expliquer la situation]

Options envisagées :
1. [Option A] - Avantages/Inconvénients
2. [Option B] - Avantages/Inconvénients

Recommandation : [votre avis]

Attente validation avant de continuer.
```

### Format des livrables

Quand une fonctionnalité est terminée :

```
✅ [Fonctionnalité X] implémentée

Fichiers modifiés :
- lib/screens/home_screen.dart (création)
- lib/widgets/direction_card.dart (création)
- lib/services/api_service.dart (modification)

Tests effectués :
- [x] Compile sans warning
- [x] Testé iOS simulator
- [x] Mode sombre/clair OK
- [x] Gestes fonctionnels

Prochaine étape suggérée : [Y]
```

---

## 🎯 Objectifs de la v1.0

**Must-Have (priorité absolue)** :
- Écran principal avec 2 directions
- Multi-trajets (drawer)
- Modal horaires complets
- Mode hors-ligne avec cache SQLite
- Ordre auto selon l'heure (matin/soir)
- Indicateur "Mis à jour il y a X"
- État "Aucun train"
- Feedback haptique
- Animations transitions

**Should-Have (important)** :
- Widget écran d'accueil
- Widget multiples configurables
- Informations de trafic (perturbations)

**Nice-to-Have (bonus)** :
- Shake to refresh
- Mode tablette

Voir `docs/FONCTIONNALITES.md` pour la checklist complète.

---

## 🔐 Sécurité et données sensibles

### Clé API SNCF

**JAMAIS dans le code** :
```dart
// ❌ JAMAIS FAIRE ÇA
const apiKey = 'ma_cle_secrete_123';
```

**Toujours via environnement ou config non-versionnée** :
```dart
// ✅ OUI
final apiKey = dotenv.env['SNCF_API_KEY'];
```

**OU via proxy Cloudflare Workers** (solution retenue) :
```dart
// ✅ OUI - La clé est dans le Worker, pas dans l'app
final response = await http.get(
  Uri.parse('https://proxy.surlequai.app/departures'),
);
```

### Fichiers à ne JAMAIS commiter

- `*.env`
- `secrets.dart`
- `api_keys.dart`
- Fichiers de config avec tokens

---

## 📚 Ressources

### Documentation officielle
- Flutter : https://docs.flutter.dev/
- Dart : https://dart.dev/guides
- Material Design : https://m3.material.io/

### API SNCF
- Documentation : https://doc.navitia.io/
- Playground : https://api.sncf.com/v1/coverage/sncf/

### Projet
- Repo GitHub : [URL du repo]
- Issues : [URL]/issues
- Discussions : [URL]/discussions

---

## ✅ Checklist avant chaque commit

- [ ] Code formaté (`dart format .`)
- [ ] Pas de warning (`flutter analyze`)
- [ ] Testé en hot reload (fonctionne sans restart)
- [ ] Commentaires à jour (si modif de logique)
- [ ] Pas de `print()` de debug (utiliser `debugPrint()`)
- [ ] Pas de TODO non documentés
- [ ] Message de commit descriptif

---

## 🎓 Résumé des principes

1. **Lire FONCTIONNALITES.md AVANT de coder**
2. **Simplicité > Complexité** toujours
3. **Performance matters** - viser 60 FPS
4. **Tester fréquemment** - hot reload est ton ami
5. **Communiquer les ambiguïtés** - ne pas deviner
6. **Code clean** - le prochain dev (toi dans 6 mois) te remerciera
7. **Respecter le design system** - pas d'improvisation visuelle
8. **Mode offline first** - toujours penser hors-ligne

---

**Version** : 1.0
**Dernière mise à jour** : 23 janvier 2026
**Auteur** : Nicolas

---

*Ce document est vivant. Mettez-le à jour si de nouvelles conventions émergent.*
