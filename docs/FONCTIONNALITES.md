# SurLeQuai - Fonctionnalités v1.0

**Version** : 1.0 MVP
**Objectif** : Application minimaliste pour afficher les prochains trains entre deux gares favorites
**Principe** : Simplicité maximale - Une seule chose, bien faite

---

## 🎯 Vue d'ensemble

### Concept de base
- Afficher en temps réel les prochains trains pour des trajets quotidiens (domicile ⟷ travail)
- Deux directions simultanées : A → B et B → A
- Mode hors-ligne avec horaires théoriques
- Multi-trajets favoris
- Zéro configuration de compte

### Priorités absolues
1. **Lisibilité** : Informations visibles d'un coup d'œil
2. **Rapidité** : Affichage instantané (cache local)
3. **Fiabilité** : Fonctionne hors-ligne
4. **Simplicité** : Zéro friction

---

## 📱 Fonctionnalités principales

### 1. Écran principal - Dashboard

#### Affichage des trains

**Pour chaque direction (A → B et B → A)** :
- **Prochain train** (90% de l'attention visuelle)
  - Heure de départ (très grande taille)
  - Voie/Quai (grande taille)
  - État temps réel : À l'heure / +X min / Supprimé
  - Barre de couleur épaisse (vert/orange/rouge/bleu)

- **Trains suivants** (10% de l'attention)
  - Sur UNE seule ligne : "Puis: 14:42  15:12"
  - Affichage discret (petit, gris)
  - Pas d'info de voie (pour rester simple)

#### États visuels

| État | Barre | Texte | Couleur | Quand |
|------|-------|-------|---------|-------|
| À l'heure | Épaisse verte | "À l'heure" (vert) | `#22C55E` | Temps réel disponible, 0-2 min retard |
| Retard | Épaisse orange | "+X min" (orange) | `#F59E0B` | Temps réel disponible, 3+ min retard |
| Supprimé | Épaisse rouge | "Supprimé" (rouge) | `#EF4444` | Temps réel, train annulé |
| Hors-ligne | Épaisse bleue | "Horaire prévu" (gris) | `#60A5FA` | Pas de réseau, cache théorique |
| Chargement | Grise | "Chargement..." (gris) | `#9CA3AF` | Transition initiale |

#### Bandeau d'information

**Hors connexion** :
```
┌─────────────────────────────────────┐
│ ⚠ Hors connexion                    │
│   Horaires théoriques uniquement    │
└─────────────────────────────────────┘
```
- Fond bleu pâle `#DBEAFE`
- Texte bleu foncé `#1E40AF`

**Synchronisation en cours** :
```
┌─────────────────────────────────────┐
│ ⟳ Mise à jour en cours...           │
└─────────────────────────────────────┘
```
- Fond jaune pâle `#FEF3C7`
- Texte brun `#92400E`
- Disparaît après mise à jour

**Nouvelle grille disponible** :
```
┌─────────────────────────────────────┐
│ ℹ Nouvelle grille horaire disponible│
│   [Télécharger maintenant]          │
└─────────────────────────────────────┘
```

#### Indicateur de fraîcheur ⭐⭐⭐ MUST-HAVE

Dans le header, affichage de l'état de mise à jour :
```
Mis à jour: il y a 30s  ← Police normale, neutre
Mis à jour: il y a 5min ← Légèrement grisé
Mis à jour: il y a 20min ← Plus grisé, moins confiance
```

**Comportement** :
- Mis à jour chaque seconde
- Couleur neutre (pas de rouge/vert, trop agressif)
- Juste information factuelle

#### État "Aucun train" ⭐⭐⭐ MUST-HAVE

Quand il n'y a plus de train (tard le soir, dimanche, etc.) :
```
│   Rennes → Nantes         ⟲   │
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                     │
│        Aucun train aujourd'hui      │
│        Premier train demain: 06:12  │
│                                     │
└─────────────────────────────────────┘
```

**Comportement** :
- Affiche le prochain train disponible (même si c'est demain)
- Message clair et non frustrant
- Évite les écrans vides incompréhensibles

---

### 2. Gestion multi-trajets (Drawer)

#### Drawer latéral

Accessible via icône `☰` en haut à gauche.

**Contenu** :
```
┌──────────────────────────┐
│ ✕  Mes trajets           │
├──────────────────────────┤
│                          │
│ ▶ Rennes ⟷ Nantes       │ ← Actif (flèche)
│                          │
│   Paris ⟷ Lyon          │
│                          │
│   Bordeaux ⟷ Toulouse   │
│                          │
├──────────────────────────┤
│                          │
│ + Ajouter un trajet      │
│                          │
└──────────────────────────┘
```

**Fonctionnalités** :
- Tap sur trajet → Bascule sur ce trajet (écran principal se met à jour)
- Long press → Menu : Modifier / Supprimer
- Swipe gauche → Suppression rapide
- Maximum 10 trajets favoris (pour garder simple)
- Interface épurée : pas d'info supplémentaire pour éviter la surcharge visuelle

**Ajout d'un trajet** :
1. Tap sur "+ Ajouter un trajet"
2. Sélection Gare A (autocomplete)
3. Sélection Gare B (autocomplete)
4. Validation → Retour au drawer
5. Nouveau trajet créé et activé

**Suppression** :
- Swipe gauche sur le trajet
- Ou Long press → Menu → Supprimer
- Confirmation si c'est le dernier trajet

---

### 3. Modal "Fiche horaire" ⭐⭐⭐ MUST-HAVE

#### Déclenchement
Tap sur la zone de direction (ex: "Rennes → Nantes")

#### Affichage (Bottom Sheet)

```
┌─────────────────────────────────────┐
│ ═══                                 │ ← Handle glissant
│                                     │
│ Fiche horaire                       │
│ Rennes → Nantes                     │
│ Horaires théoriques                 │
├─────────────────────────────────────┤
│                                     │
│ ⊘ 06:12  Voie 2                     │ ← Passés : grisé + barré
│ ⊘ 07:42  Voie 3                     │
│ ⊘ 08:12  Voie 3                     │
│                                     │
│ ▶ 14:12  Voie 3  ◀                 │ ← PROCHAIN (highlight + icône)
│                                     │
│   14:42  Voie 2                     │ ← Futurs (normaux)
│   15:12  Voie 3                     │
│   15:42  Voie 2                     │
│   16:12  Voie 3                     │
│   17:12  Voie 3                     │
│   ...                               │
│                                     │
│ ──────── Demain ────────            │ ← Séparateur jour J+1
│                                     │
│   06:12  Voie 3                     │ ← Trains de demain (grisés)
│   07:42  Voie 2                     │
│   ...                               │
│                                     │
└─────────────────────────────────────┘
```

**Comportement** :
- Charge les horaires théoriques depuis l'API Navitia (endpoint `/journeys`)
- Affiche **jour J + jour J+1** avec séparateur visuel
- Cache SharedPreferences par jour de service (1 appel API max par jour)
- Filtrage client-side pour respecter les limites de jour (4h-4h)
- Scroll vertical fluide
- Swipe vers le bas pour fermer
- Tap en dehors pour fermer
- Auto-scroll vers le prochain train au démarrage
- Horaires passés grisés et barrés
- Prochain train visuellement distinct (icône flèche + gras)
- États loading/error gérés

**Données affichées** :
- Heure de départ théorique
- Voie (si disponible)
- **PAS de temps réel** (données théoriques uniquement)
- Distinction claire passé/présent/futur
- Trains de demain en gris

**Implémentation technique** :
- Widget `SchedulesModal` stateful
- Appel API : `getTheoreticalSchedule()` avec `data_freshness=base_schedule`
- Cache : `journeys_{fromId}_{toId}_{serviceDay}` dans SharedPreferences
- Limite : 100 trains par jour (`AppConstants.maxTrainsPerDay`)
- Filtrage : Trains entre 4h aujourd'hui et 4h demain (puis 4h demain et 4h après-demain)

---

### 4. Ordre automatique selon l'heure ⭐⭐⭐ MUST-HAVE

#### Concept
Les trajets domicile-travail ont un sens différent selon l'heure :
- **Matin** : Domicile → Travail
- **Soir** : Travail → Domicile

#### Fonctionnalité

**Dans Settings** :
```
┌─────────────────────────────────┐
│ Ordre d'affichage                │
│                                  │
│ ○ Fixe (toujours A→B puis B→A)  │
│ ● Auto (selon l'heure)           │
│                                  │
│ Si Auto activé:                  │
│ ┌─────────────────────────────┐ │
│ │ Priorité matin (6h-13h)     │ │
│ │ → Rennes → Nantes           │ │
│ │                             │ │
│ │ Priorité soir (13h-22h)     │ │
│ │ → Nantes → Rennes           │ │
│ └─────────────────────────────┘ │
│                                  │
│ [Personnaliser les heures]       │
└─────────────────────────────────┘
```

**Valeur par défaut** :
- Mode Auto activé
- Matin : 6h-13h
- Après-midi/Soir : 13h-22h
- Nuit : Ordre fixe A→B puis B→A

**Comportement sur l'écran principal** :
```
À 8h du matin:
┌─────────────────────────────────────┐
│   Rennes → Nantes         ⟲   │ ← EN PREMIER (priorité)
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│        08:12      Voie 3            │
│   Puis: 08:42  09:12                │
├─────────────────────────────────────┤
│   Nantes → Rennes         ⟲   │ ← En second
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│        18:27      Voie 1            │
│   Puis: 18:57  19:27                │
└─────────────────────────────────────┘

À 18h (après-midi):
┌─────────────────────────────────────┐
│   Nantes → Rennes         ⟲   │ ← EN PREMIER (priorité)
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│        18:27      Voie 1            │
│   Puis: 18:57  19:27                │
├─────────────────────────────────────┤
│   Rennes → Nantes         ⟲   │ ← En second
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│        (demain) 06:12     Voie 3    │
│   Puis: 07:42  08:12                │
└─────────────────────────────────────┘
```

**Impact UX** :
- Énorme : la direction pertinente est toujours en haut
- Pas besoin de scroller
- Expérience quotidienne optimale

---

### 5. Widget écran d'accueil ⭐⭐⭐ MUST-HAVE

#### Widget Android/iOS

**Taille** : Medium (2x2 ou équivalent)

**Contenu** :
```
┌─────────────────────────┐
│ SurLeQuai               │
│                         │
│ Rennes → Nantes         │
│ 14:12  Voie 3  🟢       │ ← Prochain train
│                         │
│ Nantes → Rennes         │
│ 14:27  Voie 1  🟠 +5    │
│                         │
│ Mis à jour: 13:42       │
└─────────────────────────┘
```

**Comportement** :
- Tap sur widget → Ouvre l'app
- Tap sur une direction → Ouvre l'app avec modal horaires de cette direction

#### Widgets multiples ⭐⭐⭐ MUST-HAVE

**Fonctionnalité** :
- L'utilisateur peut ajouter **plusieurs widgets** sur son écran d'accueil
- Chaque widget affiche un trajet différent parmi les trajets favoris
- **Cas d'usage** : Trajet avec correspondance (ex: Bruz → Rennes + Rennes → Betton)

**Configuration** :
- Lors de l'ajout d'un widget, une **Activity de configuration** s'affiche
- L'utilisateur choisit quel trajet ce widget doit afficher
- Chaque widget conserve sa configuration de manière indépendante

**Implémentation Android** :
- Utilisation de `appWidgetId` pour identifier chaque instance
- Stockage : `widget_{appWidgetId}_trip_id` → "trip-uuid-xxx"
- Configuration Activity Android standard

#### Stratégie de rafraîchissement intelligente ⭐⭐⭐ MUST-HAVE

**Principe** : Économie de batterie maximale tout en ayant les infos quand il faut.

**Logique de rafraîchissement** :

1. **Après le départ du train** (heure H passée) :
   - Pas de rafraîchissement jusqu'à **H-20** du prochain train
   - Économie batterie maximale pendant les périodes creuses

2. **Approche du prochain départ** :
   ```
   H-20 min : Rafraîchissement (premier check)
   H-15 min : Rafraîchissement
   H-10 min : Rafraîchissement
   H-5 min  : Rafraîchissement
   H (départ) : Rafraîchissement final
   ```

3. **Gestion des retards** :
   - Si retard détecté : H ← H + retard prévu
   - Exemple : Train prévu 14:12, retard +5min → H = 14:17
   - Les rafraîchissements s'adaptent : H-20 = 13:57, H-15 = 14:02, etc.

4. **Cas particuliers** :
   - **Nuit** (0h-5h) : Pas de rafraîchissement (pas de trains)
   - **Dernier train passé** : Pas de rafraîchissement jusqu'au lendemain matin
   - **Aucun train** : Rafraîchissement uniquement à H-20 du prochain train (même si c'est demain)

**Avantages** :
- ✅ Batterie économisée (pas de poll constant)
- ✅ Infos fraîches quand l'utilisateur en a besoin
- ✅ Adaptation dynamique aux retards
- ✅ Expérience utilisateur optimale

**Implémentation technique** :
- Utilisation de `WorkManager` (Android) pour planification dynamique
- Calcul du prochain rafraîchissement à chaque update
- Annulation/reprogrammation automatique selon le contexte

**Indicateurs visuels** :
- Pastilles colorées 🟢🟠🔴🔵 selon état
- Texte du retard si applicable
- Si hors-ligne : symbole ⚠ + "Horaire prévu"

---

### 6. Gestes et interactions

#### Gestes principaux

| Geste | Zone | Action |
|-------|------|--------|
| **Pull-to-refresh ↓** | Écran principal | Force rafraîchissement données |
| **Tap** | "Rennes → Nantes" | Ouvre modal horaires complets |
| **Tap** | Bouton ⟲ | Force rafraîchissement |
| **Tap** | ☰ (menu) | Ouvre drawer trajets |
| **Tap** | ⚙️ (settings) | Ouvre paramètres |

> **Note** : L'ordre d'affichage (A→B ou B→A en premier) se fait **automatiquement** selon l'heure de la journée, configurable dans les Paramètres. Pas besoin de geste manuel.

#### Drawer - Gestes

| Geste | Zone | Action |
|-------|------|--------|
| **Tap** | Trajet | Active ce trajet |
| **Long press** | Trajet | Menu contextuel (Modifier/Supprimer) |
| **Swipe ←** | Trajet | Suppression rapide |
| **Tap** | + Ajouter | Formulaire nouveau trajet |

#### Modal horaires - Gestes

| Geste | Zone | Action |
|-------|------|--------|
| **Swipe ↓** | Handle ou contenu | Fermer modal |
| **Tap** | Extérieur modal | Fermer modal |
| **Scroll** | Liste | Parcourir horaires |

#### Feedback haptique ⭐⭐ SHOULD-HAVE

Retours tactiles subtils pour renforcer les actions :

```dart
// Changement de trajet dans drawer
HapticFeedback.lightImpact();

// Inversion A ⟷ B
HapticFeedback.selectionClick();

// Rafraîchissement terminé
HapticFeedback.mediumImpact();

// Erreur (pas de réseau, etc.)
HapticFeedback.heavyImpact();
```

**Activation** :
- Activé par défaut
- Désactivable dans Settings

---

### 7. Animations et transitions ⭐⭐ SHOULD-HAVE

#### Transitions entre trajets

Quand on change de trajet dans le drawer :
```
Trajet actuel (Rennes ⟷ Nantes)
    ↓ Fade out (150ms)
Écran vide
    ↓ Fade in (150ms)
Nouveau trajet (Paris ⟷ Lyon)
```

**Durée totale** : 300ms
**Courbe** : ease-in-out
**Objectif** : Transition douce, pas brutale

#### Pull-to-refresh

- Indicateur spinner pendant le chargement
- Animation de "rebond" quand on relâche
- Transition douce vers les nouvelles données

#### Ouverture/Fermeture modal

- Bottom sheet glisse de bas en haut (300ms)
- Fond assombri progressif (overlay)
- Fermeture inverse (glisse vers le bas)

#### États de barre de couleur

Transition douce entre états :
```
Vert (à l'heure)
    ↓ 200ms transition
Orange (retard détecté)
    ↓ 200ms transition
Rouge (retard important)
```

Évite les changements brutaux qui attirent trop l'œil.

---

## 💾 Gestion des données

### Architecture de stockage (Simplifiée)

#### 1. Cache API temps réel (Fichiers JSON locaux) ✅

**Service** : `StorageService`

**Structure** :
```
app_documents/
└── schedules_cache/
    ├── cache_fromID_toID.json
    ├── cache_fromID2_toID2.json
    └── ...
```

**Format d'un fichier cache** :
```json
{
  "updated_at": "2026-01-27T14:30:00Z",
  "departures": [
    {
      "id": "trip_123-1738072200000",
      "scheduledTime": "2026-01-27T14:12:00Z",
      "platform": "3",
      "status": "onTime",
      "delayMinutes": 0,
      "durationMinutes": 76
    }
  ]
}
```

**Fonctionnement** :
- Cache des dernières réponses API temps réel (6 trains)
- Utilisé en mode offline quand l'API n'est pas joignable
- Durée de vie : Pas de limite stricte (dernières données disponibles)
- Mise à jour : À chaque rafraîchissement réussi
- Taille : ~5-10 KB par trajet (négligeable)

#### 2. Cache horaires théoriques (SharedPreferences) ✅

**Pour la modale "Fiche horaire"**

**Clés de cache** :
```
journeys_{fromId}_{toId}_{serviceDay}
```
Exemple : `journeys_87471003_87481002_2026-01-27`

**Contenu** : Liste JSON de 100 trains théoriques (jour complet)

**Fonctionnement** :
- Cache par jour de service (4h-4h)
- 1 appel API maximum par jour et par trajet
- Invalidation automatique à 4h du matin
- Utilisé uniquement pour la modale (pas l'écran principal)

#### 3. Trajets favoris (SharedPreferences) ✅

**Clé** : `trips`

```json
[
  {
    "id": "trip-uuid-xxx",
    "stationA": {
      "id": "stop_area:SNCF:87471003",
      "name": "Rennes"
    },
    "stationB": {
      "id": "stop_area:SNCF:87481002",
      "name": "Nantes"
    },
    "morningDirection": "aToB",
    "createdAt": "2026-01-20T10:30:00Z"
  }
]
```

**Clé** : `activeTripId` → ID du trajet actif

#### 4. Settings (SharedPreferences) ✅

**Clés** :
- `themeMode` : "light" | "dark" | "system"
- `splitTime` : Heure de bascule matin/soir (int, défaut 13)
- `dayStartTime` : Heure de début de journée (int, défaut 4)

### Simplification vs version initiale

**Ancienne architecture** (v0.x) :
- SQLite avec tables complexes
- Import GTFS
- Gestion versions de grilles horaires
- ~50 MB de données

**Nouvelle architecture** (v1.0) :
- Cache JSON léger (~5-10 KB par trajet)
- API en temps réel uniquement
- SharedPreferences pour horaires théoriques
- Mode offline via cache des dernières données API

### Flux de données au lancement ✅

```
1. App démarre
   ├─ Affiche skeleton/placeholder
   │
2. Charge SharedPreferences (50ms)
   ├─ Trajets favoris
   ├─ Settings (thème, heures bascule)
   └─ Trajet actif
   │
3. Charge cache JSON local (50ms)
   ├─ Filtre par trajet actif
   ├─ Lit cache_fromID_toID.json
   └─ Affiche avec état "Horaire prévu" (bleu) si données présentes
   │
4. Vérifie réseau et appelle API temps réel
   ├─ [Si réseau disponible]
   │  ├─ Appel API /journeys (data_freshness=realtime)
   │  ├─ Récupère 6 prochains trains avec retards/suppressions
   │  ├─ Sauvegarde dans cache JSON (mise à jour)
   │  └─ Met à jour affichage (vert/orange/rouge)
   │
   └─ [Si pas de réseau]
      ├─ Affiche bandeau "Hors connexion"
      └─ Reste sur cache JSON (bleu) si disponible
```

**Objectif temps** :
- Affichage cache local : < 100ms
- Affichage temps réel : < 1000ms (selon réseau)

**Stratégie offline** :
- Cache JSON permet de fonctionner complètement offline
- Pas besoin de grilles horaires lourdes
- Les 6 derniers trains récupérés suffisent pour 90% des cas
- En cas de cache vide : Message "Aucun train" + recommandation de se connecter

### Rafraîchissement automatique ✅

**En mode online** :
```
Toutes les 60 secondes (configurable):
├─ Appel API /journeys (6 trains)
├─ Sauvegarde dans cache JSON
├─ Met à jour affichage (vert/orange/rouge)
└─ Met à jour indicateur "Mis à jour il y a X"
```

**En mode offline** :
```
Toutes les 5 minutes:
├─ Tente de se reconnecter (appel API)
├─ Si succès → Bascule en mode online + mise à jour
└─ Sinon → Reste en mode offline (cache JSON)
```

**Économie batterie** :
- App en arrière-plan → Pas de rafraîchissement app
- Écran éteint → Pas de rafraîchissement app
- Widget actif → Rafraîchissement intelligent WorkManager (H-20, H-15, H-10, H-5, H-0)

### Cache et gestion offline ✅

**Stratégie simplifiée** :
- Pas de grilles horaires lourdes à télécharger
- Cache léger des dernières données API (6 trains)
- Fonctionne offline avec les dernières données récupérées
- Modal "Fiche horaire" : Cache SharedPreferences par jour (100 trains)

**Avantages** :
- ✅ Pas de téléchargement lourd au premier lancement
- ✅ Pas de gestion de versions complexe
- ✅ Stockage minimal (~10 KB par trajet)
- ✅ Mode offline fonctionnel immédiatement après le premier lancement
- ✅ Toujours à jour (pas de grilles obsolètes)

**Inconvénients acceptés** :
- ⚠️ Nécessite au moins une connexion au premier lancement
- ⚠️ Cache limité à 6 trains (suffisant pour 90% des usages)
- ⚠️ Pas de planification long terme offline (acceptable pour usage quotidien)

---

## ⚙️ Paramètres (Settings)

### Interface Settings

```
┌─────────────────────────────────────┐
│ ← Paramètres                        │
├─────────────────────────────────────┤
│                                     │
│ AFFICHAGE                           │
│                                     │
│ Thème                               │
│ ○ Clair  ● Auto  ○ Sombre          │
│                                     │
│ Ordre d'affichage automatique       │
│ Trajet du matin : Rennes → Nantes  │
│ [Inverser]                          │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ COMPORTEMENT HORAIRE                │
│                                     │
│ Bascule matin/soir                  │
│ Heure : 13h                         │
│ [Modifier]                          │
│                                     │
│ Début du jour de service            │
│ Heure : 4h                          │
│ [Modifier]                          │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ DONNÉES                             │
│                                     │
│ Vider le cache                      │
│ Supprime les horaires théoriques    │
│ [Vider]                             │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ À PROPOS                            │
│                                     │
│ Version: 1.0.0 (build 1)            │
│ [Code source sur GitHub]            │
│ [Signaler un bug]                   │
│ [Mentions légales]                  │
│                                     │
│ Easter egg 🕐                       │
│ Le logo affiche 16:50 en référence  │
│ au roman d'Agatha Christie          │
│ "Le Train de 16h50" (1957)          │
│                                     │
└─────────────────────────────────────┘
```

### Paramètres détaillés

#### Thème
- **Clair** : Fond blanc, texte noir
- **Sombre** : Fond noir, texte blanc
- **Auto** : Suit le système (iOS/Android)

**Valeur par défaut** : Auto

#### Ordre d'affichage

**Mode Auto** :
- Matin (6h-13h par défaut) : Direction A → B en premier
- Soir (13h-22h par défaut) : Direction B → A en premier
- Nuit (22h-6h) : Ordre fixe A → B

**Mode Fixe** :
- Toujours A → B puis B → A
- Pas de changement selon l'heure

**Personnalisation** :
```
┌─────────────────────────────────┐
│ Personnaliser les horaires       │
│                                  │
│ Période matin                    │
│ De: [06:00] À: [13:00]          │
│ Afficher en premier:             │
│ ● Rennes → Nantes (A → B)       │
│                                  │
│ Période soir/après-midi          │
│ De: [13:00] À: [22:00]          │
│ Afficher en premier:             │
│ ● Nantes → Rennes (B → A)       │
│                                  │
│ [Enregistrer]                    │
└─────────────────────────────────┘
```

#### Fréquence rafraîchissement
- 30 secondes (données très fraîches, batterie -)
- 60 secondes (recommandé, équilibré)
- 2 minutes (économie batterie)
- 5 minutes (max économie)

**Valeur par défaut** : 60 secondes

#### Retour haptique
- Activé par défaut
- Vibrations légères sur interactions (tap, swipe, etc.)
- Désactivable pour ceux qui n'aiment pas

---

## 🚨 Informations de trafic (optionnel, à explorer)

### Perturbations et incidents

L'API Navitia (base de l'API SNCF) fournit des informations sur les perturbations en temps réel.

**Endpoint** : `/disruptions` ou `/traffic_reports`

**Types d'informations disponibles** :
- Travaux prévus sur la ligne
- Incidents en cours
- Messages d'information voyageurs
- Perturbations sur le réseau

### Affichage potentiel

**Bandeau d'information** (si perturbation affectant le trajet actif) :
```
┌─────────────────────────────────────┐
│ ⚠ Trafic perturbé                   │
│   Travaux sur la ligne - Retards    │
│   possibles de 10 à 15 min          │
│   [Plus d'infos]                    │
└─────────────────────────────────────┘
```

**Principe** :
- Affichage uniquement si perturbation significative
- Lien vers détails (modal ou navigateur)
- Pas de spam d'informations mineures
- Respect de la philosophie minimaliste

**Note** : À implémenter après la mise en production des fonctionnalités core, car ajoute de la complexité. L'application doit d'abord fonctionner parfaitement sans ces infos.

---

## 🎨 Interface et design

### Modes d'affichage

#### Mode clair
- Fond : `#FFFFFF`
- Texte : `#111827`
- Cartes : Fond `#F9FAFB`, bordure `#E5E7EB`

#### Mode sombre
- Fond : `#1F2937`
- Texte : `#F9FAFB`
- Cartes : Fond `#374151`, bordure `#4B5563`

### Palette de couleurs

```css
/* États des trains */
--color-on-time: #22C55E;         /* Vert */
--color-delayed: #F59E0B;         /* Orange */
--color-canceled: #EF4444;        /* Rouge */
--color-offline: #60A5FA;         /* Bleu pâle */
--color-secondary: #9CA3AF;       /* Gris */

/* Bandeaux d'information */
--offline-bg: #DBEAFE;
--offline-text: #1E40AF;
--loading-bg: #FEF3C7;
--loading-text: #92400E;
--success-bg: #D1FAE5;
--success-text: #065F46;

/* Interface mode clair */
--bg-light: #FFFFFF;
--text-light: #111827;
--card-bg-light: #F9FAFB;
--border-light: #E5E7EB;

/* Interface mode sombre */
--bg-dark: #1F2937;
--text-dark: #F9FAFB;
--card-bg-dark: #374151;
--border-dark: #4B5563;
```

### Typographie

**Familles** :
- Système par défaut (SF Pro sur iOS, Roboto sur Android)
- Pas de police custom (simplicité)

**Tailles** :
- Heure prochain train : 48-56px (énorme)
- Voie : 24-28px (grande)
- État : 20-24px (moyenne)
- Horaires suivants : 16-18px (petite)
- Textes secondaires : 14px (très petite)

**Poids** :
- Heure : Bold (700)
- Voie : Medium (500)
- Reste : Regular (400)

---

## 📡 API et endpoints

### API Navitia (SNCF Open Data) - Endpoints utilisés ✅

#### 1. Itinéraires directs (temps réel) ✅

```
GET https://api.sncf.com/v1/coverage/sncf/journeys
Query params:
  - from: "stop_area:SNCF:87471003"
  - to: "stop_area:SNCF:87481002"
  - datetime: "20260127T140000" (format: YYYYMMDDTHHmmss)
  - count: 6 (écran principal) ou 100 (modale)
  - data_freshness: "realtime" (écran principal) ou "base_schedule" (modale)
  - max_nb_transfers: 0 (trains directs uniquement)
  - min_nb_journeys: 6

Headers:
  - Authorization: Basic {base64(api_key)}

Response (simplifié):
{
  "journeys": [
    {
      "departure_date_time": "20260127T141200",
      "arrival_date_time": "20260127T152800",
      "duration": 4560,
      "nb_transfers": 0,
      "sections": [
        {
          "type": "public_transport",
          "departure_date_time": "20260127T141200",
          "arrival_date_time": "20260127T152800",
          "display_informations": {
            "network": "TER Bretagne",
            "trip_short_name": "857142"
          },
          "stop_date_times": [
            {
              "departure_stop_point": {
                "platform": "3"
              }
            }
          ]
        }
      ]
    }
  ]
}
```

**Utilisé pour** :
- Écran principal : `data_freshness=realtime`, `count=6`
- Modal "Fiche horaire" : `data_freshness=base_schedule`, `count=100`

#### 2. Recherche de gares ✅

```
GET https://api.sncf.com/v1/coverage/sncf/places
Query params:
  - q: "renn"
  - type[]: "stop_area"
  - count: 50

Response:
{
  "places": [
    {
      "id": "stop_area:SNCF:87471003",
      "name": "Gare de Rennes",
      "embedded_type": "stop_area"
    }
  ]
}
```

**Utilisé pour** : Recherche de gares dans `StationPickerScreen`

### Proxy Cloudflare Workers

**Rôle** :
- Cacher la clé API SNCF
- Rate limiting par IP (100 req/h)
- Mise en cache intelligente
- Compression des réponses

**Configuration** :
```javascript
// wrangler.toml
name = "surlequai-proxy"
compatibility_date = "2024-01-01"

[vars]
SNCF_API_BASE = "https://api.sncf.com/v1"

[[kv_namespaces]]
binding = "CACHE"
id = "..."
```

---

## 🧪 Tests et validation

### Tests unitaires implémentés ✅

**Fichier** : `test/trip_provider_test.dart`

**Couverture** :
- ✅ Tri automatique matin/soir (`_shouldSwapOrder`)
- ✅ Injection de dépendances (ApiService, StorageService, etc.)
- ✅ Mocks manuels pour isolation
- ✅ Tests du comportement selon l'heure (matin/soir/nuit)
- ✅ Tests avec différentes configurations (morningDirection aToB/bToA)

**Exécution** :
```bash
flutter test test/trip_provider_test.dart
```

### Tests fonctionnels à effectuer

#### Données
- [x] Chargement cache JSON local ✅
- [x] Récupération temps réel depuis API Navitia ✅
- [x] Sauvegarde cache après appel API ✅
- [x] Gestion perte réseau (passage online → offline) ✅
- [x] Gestion récupération réseau (passage offline → online) ✅
- [x] Cache SharedPreferences horaires théoriques (modale) ✅
- [ ] Tests intégration complets avec API réelle

#### Interface
- [ ] Affichage prochain train (toutes les couleurs)
- [ ] Affichage trains suivants
- [ ] Bandeau hors connexion
- [ ] Bandeau synchronisation
- [ ] Indicateur "Mis à jour il y a X"
- [ ] État "Aucun train"
- [ ] Mode sombre / clair
- [ ] Transitions animations

#### Multi-trajets
- [ ] Ajout d'un trajet
- [ ] Suppression d'un trajet
- [ ] Changement de trajet actif
- [ ] Drawer avec liste trajets
- [ ] Info prochain train dans drawer

#### Modal horaires
- [ ] Ouverture/fermeture fluide
- [ ] Scroll vertical
- [ ] Highlight prochain train
- [ ] Horaires passés grisés
- [ ] Auto-scroll vers prochain

#### Ordre auto
- [ ] Détection plage horaire
- [ ] Inversion automatique matin/soir
- [ ] Configuration personnalisée
- [ ] Mode fixe

#### Gestes
- [ ] Pull-to-refresh
- [ ] Tap pour ouvrir modal
- [ ] Feedback haptique

#### Widget (si implémenté)
- [ ] Affichage données
- [ ] Mise à jour périodique
- [ ] Tap pour ouvrir app
- [ ] Multi-états (vert/orange/rouge/bleu)

#### Performance
- [ ] Temps de lancement < 200ms (horaires théoriques)
- [ ] Temps rafraîchissement < 1s
- [ ] Pas de lag lors du scroll
- [ ] Animations 60 fps

---

## 📦 Livrables v1.0

### Code
- [ ] Application Flutter complète
- [ ] Cloudflare Worker (proxy API)
- [ ] README.md détaillé
- [ ] CONTRIBUTING.md
- [ ] LICENSE (GPL v3 ou MIT)

### Documentation
- [ ] Guide d'installation
- [ ] Guide d'utilisation
- [ ] Documentation API
- [ ] Architecture technique

### Distribution
- [ ] APK Android (GitHub Releases)
- [ ] F-Droid (soumission)
- [ ] Google Play (optionnel)
- [ ] App Store iOS (optionnel, si budget)

### Communication
- [ ] Post LinuxFR
- [ ] Post forum SNCF Open Data
- [ ] Post Reddit /r/france
- [ ] Page projet GitHub complète

---

## 📊 État d'avancement détaillé

### ⚠️ Compatibilité plateformes

**Plateformes cibles** : iOS + Android (priorité Android FIRST)

**Développement et tests** :
- ✅ Chrome/macOS : Développement UI rapide (hot reload)
- ✅ Android émulateur/physique : Tests complets incluant widgets
- ✅ Simulateur iOS : Validation UI (widgets non testables sans compte Apple Developer)
- ❌ iPhone physique : Bloqué sans compte Apple Developer (99$/an)

**Limitations techniques** :
- `home_widget` : iOS/Android uniquement (n'est appelé que sur mobile via vérification plateforme)
- `sqflite` : iOS/Android uniquement (mode dégradé sur Web/Desktop)
- Web/Desktop : Interface fonctionnelle mais sans cache SQLite ni widgets

**Note** : L'app fonctionne sur toutes les plateformes mais les fonctionnalités avancées (widgets, cache SQLite) sont réservées aux mobiles, ce qui est cohérent avec le concept de l'application.

### ✅ Fonctionnalités complètes

**Widgets écran d'accueil** (100%) ✅ COMPLET :
- ✅ Service `WidgetService` avec gestion multi-widgets (clés préfixées par tripId)
- ✅ Background callback `backgroundCallback()` avec `@pragma('vm:entry-point')`
- ✅ Mise à jour automatique de tous les widgets via `updateAllWidgets()`
- ✅ Gestion complète des états (onTime, delayed, cancelled, offline)
- ✅ AppGroup configuré pour iOS (`group.com.surlequai.app`)
- ✅ Package `home_widget` v0.9.0 intégré
- ✅ Prise en compte des retards dans le calcul du prochain train
- ✅ **WorkManager rafraîchissement intelligent** :
  - Échelle H-20, H-15, H-10, H-5, H-0 (ligne 170 SurLeQuaiWidgetProvider.kt)
  - Adaptation dynamique aux retards
  - Calcul prochain départ entre les deux directions
  - Pause après départ jusqu'à H-20 du prochain
  - WidgetRefreshWorker déclenche backgroundCallback Dart
  - Gestion passage minuit

**Multi-trajets** (95%) :
- ✅ Provider `TripProvider` avec ChangeNotifier
- ✅ Drawer UI avec liste, suppression, activation
- ✅ Validation complète (max 10, pas doublons, stations différentes)
- ✅ Persistance SharedPreferences
- ✅ Écran ajout trajet avec station picker
- ✅ Minimum 1 trajet obligatoire
- ⚠️ **Manque** : Long press menu contextuel, swipe-to-delete, édition trajet

**Interface utilisateur** (100%) :
- ✅ `DirectionCard` avec variantes (with/without departures)
- ✅ `SchedulesModal` charge ses données depuis API avec cache
- ✅ Modal affiche jour J + J+1 avec séparateur
- ✅ Durée de trajet affichée dans les cartes principales (⏱️ X min)
- ✅ `StatusBanner` animé (offline/syncing/error)
- ✅ `LastUpdateIndicator` avec temps relatif et opacité progressive
- ✅ `TripsDrawer` complet
- ✅ Layout 2 directions sur `HomeScreen`
- ✅ Tous les états visuels (vert/orange/rouge/bleu)
- ✅ Recherche de gares via API avec debouncing

**Mode hors-ligne** (100%) ✅ :
- ✅ `StorageService` simplifié avec cache JSON (plus de SQLite)
- ✅ Cache des dernières réponses API (6 trains)
- ✅ Gestion gracieuse des erreurs réseau
- ✅ Enum `ConnectionStatus` (offline, syncing, online, error)
- ✅ Fonctionne complètement offline après première connexion
- ✅ Compatible toutes plateformes (pas de dépendance SQLite)

**Thématisation** (100%) :
- ✅ Thème light + dark complets
- ✅ Palette centralisée dans `colors.dart`
- ✅ Text styles centralisés dans `text_styles.dart`
- ✅ Mode système supporté (`AppThemeMode.system`)
- ✅ Material 3 activé

**Ordre automatique matin/soir** (100%) :
- ✅ Logique `_shouldSwapOrder()` dans TripProvider
- ✅ Configuration paramétrable (heure bascule, début/fin service)
- ✅ Prise en compte des retards pour le tri
- ✅ Enum `MorningDirection` (aToB ou bToA)
- ✅ Persistance dans SharedPreferences

**Animations et feedback** (70%) :
- ✅ StatusBanner animé (300ms, easeInOut)
- ✅ Durées standardisées (150ms/300ms/500ms)
- ✅ Scroll animé dans modal (300ms)
- ✅ Opacité progressive LastUpdateIndicator
- ✅ Feedback haptique : refresh (mediumImpact), suppression (lightImpact)
- ⚠️ **Manque** : Haptique sélection (selectionClick), erreur (heavyImpact)
- ⚠️ **Manque** : Transitions fade entre trajets

**Détails importants** (100%) :
- ✅ État "Aucun train" avec affichage prochain train demain
- ✅ Indicateur "Mis à jour il y a X" avec refresh chaque seconde
- ✅ Détection retards dans le tri (train retardé peut passer après un à l'heure)
- ✅ Pull-to-refresh avec RefreshIndicator natif
- ✅ Horaires TER réalistes Rennes ⟷ Nantes dans mock data
- ✅ Auto-scroll modal vers prochain train

### ✅ Récemment implémenté

**27 janvier 2026** :
- ✅ **Architecture simplifiée** : Remplacement SQLite → Cache JSON léger
- ✅ **Mode offline complet** : Cache des réponses API temps réel (6 trains)
- ✅ **Tests unitaires** : `TripProvider` avec injection de dépendances
- ✅ **Suppression mock data** : API réelle utilisée partout
- ✅ **Fix bugs** : Spinner infini, liste trajets vide, tri matin/soir extrait

**25 janvier 2026** :
- ✅ **Rafraîchissement intelligent widgets** : WorkManager H-20/15/10/5/0
- ✅ **Modal "Fiche horaire"** : Charge depuis API avec cache SharedPreferences
- ✅ **Durée de trajet** : Affichée dans les cartes (⏱️ X min)
- ✅ **Recherche gares** : API Navitia avec debouncing
- ✅ **Journée de service** : 4h-4h au lieu de 4h-22h

### 🚧 À implémenter (Avant release)

**Proxy Cloudflare Workers** (Sécurité) :
- ❌ Déployer Worker pour cacher clé API
- ❌ Rate limiting par IP
- ❌ Compression réponses
- **Impact** : Sécurise l'accès API + améliore perfs

**Polish & tests** :
- ⚠️ Tests intégration API
- ⚠️ Tests widgets Android
- ⚠️ Tests mode offline complet
- ⚠️ Validation toutes plateformes

### 📋 Nice-to-Have (Bonus)

- ❌ Shake to refresh
- ❌ Mode tablette/paysage
- ❌ Édition trajet existant (actuellement: ajout/suppression seulement)
- ❌ Long press menu contextuel drawer
- ❌ Swipe-to-delete dans drawer
- ❌ Informations de trafic (perturbations API Navitia)

---

## ✅ Checklist finale v1.0

### Must-Have (Priorité absolue)

#### Interface
- [x] Écran principal avec 2 directions **FAIT**
- [x] États visuels (vert/orange/rouge/bleu) **FAIT**
- [x] Bandeau hors connexion **FAIT**
- [x] Indicateur "Mis à jour il y a X" ⭐⭐⭐ **FAIT**
- [x] État "Aucun train" ⭐⭐⭐ **FAIT**
- [x] Mode sombre + clair **FAIT**
- [x] Animations transitions ⭐⭐ **FAIT**

#### Multi-trajets
- [x] Drawer latéral **FAIT**
- [x] Ajout/suppression trajets **FAIT**
- [x] Changement trajet actif **FAIT**
- [x] Interface épurée (pas d'info supplémentaire dans drawer) **FAIT**

#### Modal
- [x] Modal horaires complets **FAIT**
- [x] Scroll vers prochain train **FAIT**
- [x] Horaires passés grisés **FAIT**

#### Données
- [x] Cache JSON léger (remplace SQLite) ✅ **FAIT**
- [x] API temps réel Navitia ✅ **FAIT**
- [x] Mode hors-ligne complet ✅ **FAIT**
- [x] Cache SharedPreferences pour horaires théoriques ✅ **FAIT**
- [x] Rafraîchissement auto ✅ **FAIT**

#### Ordre auto ⭐⭐⭐
- [x] Détection plage horaire **FAIT**
- [x] Inversion auto matin/soir **FAIT**
- [x] Configuration personnalisée **FAIT**

#### Gestes
- [x] Pull-to-refresh **FAIT**
- [x] Feedback haptique ⭐⭐ **FAIT** (refresh + suppression, manque: sélection + erreur)

### Should-Have (Important mais pas bloquant)

- [x] Widget écran d'accueil ⭐⭐⭐ ✅ **FAIT**
- [x] Widget multiples configurables ⭐⭐⭐ ✅ **FAIT**
- [x] Stratégie rafraîchissement intelligente widget ⭐⭐⭐ ✅ **FAIT**
- [x] Tests unitaires ⭐⭐ ✅ **FAIT** (TripProvider)
- [ ] Informations de trafic (perturbations via API Navitia)

### Nice-to-Have (Bonus si temps)

- [ ] Shake to refresh
- [ ] Mode tablette/paysage

---

## 🚀 Prochaines étapes

### Avant release v1.0

**Priorité HAUTE** :

1. **Proxy Cloudflare Workers** (Sécurité) 🔒
   - Déployer Worker pour cacher la clé API Navitia
   - Rate limiting par IP (100 req/h)
   - Compression des réponses
   - Logs et monitoring
   - **Impact** : Sécurise l'accès API + protège le quota

2. **Tests d'intégration complets** 🧪
   - Tests avec API réelle
   - Scénarios offline/online
   - Tests widgets Android
   - Validation toutes plateformes
   - Performance (< 100ms cache, < 1s API)

3. **Documentation utilisateur** 📖
   - Guide d'utilisation
   - FAQ
   - Screenshots
   - Vidéo démo (optionnel)

**Priorité MOYENNE** :

4. **Polish UI** ✨
   - Long press menu contextuel drawer
   - Swipe-to-delete dans drawer
   - Feedback haptique complet (sélection, erreur)
   - Transitions fade entre trajets

5. **Informations de trafic** (exploration) 🚧
   - Étudier API Navitia `/disruptions`
   - Design bandeau perturbations
   - Implémentation si pertinent

**Nice-to-Have** :

6. **Shake to refresh** 📱
   - Détection du geste
   - Feedback haptique
   - Quick win sympathique

7. **Mode tablette** 📱
   - Layout adaptatif
   - Optimisation paysage

### Post-release v1.0

- Feedback utilisateurs
- Optimisations performance
- Nouvelles fonctionnalités selon demandes

---

## 📈 Avancement global

**État actuel** : ~98% de la v1.0 🎉

**Fonctionnel pour production** :
- ✅ Interface utilisateur complète et fluide
- ✅ Gestion multi-trajets robuste
- ✅ Widgets écran d'accueil multi-instances avec rafraîchissement intelligent
- ✅ WorkManager Android avec échelle H-20/15/10/5/0
- ✅ Mode hors-ligne complet avec cache JSON
- ✅ API Navitia intégrée (temps réel + horaires théoriques)
- ✅ Modal "Fiche horaire" avec jour J + J+1
- ✅ Durée de trajet affichée
- ✅ Recherche de gares via API
- ✅ Thématisation complète (light/dark/system)
- ✅ Tests unitaires (TripProvider)
- ✅ Architecture simplifiée (JSON au lieu de SQLite)

**Reste avant production** :
- ⚠️ Proxy Cloudflare Workers (sécurité clé API)
- ⚠️ Tests intégration + validation complète
- ⚠️ Documentation utilisateur finale

**Architecture et qualité** :
- ✅ Code structuré selon CLAUDE.md
- ✅ Séparation concerns (services/screens/widgets/models)
- ✅ Gestion d'état centralisée (Provider)
- ✅ Injection de dépendances pour testabilité
- ✅ Error handling cohérent
- ✅ Compatible iOS/Android + Web/Desktop
- ✅ Cache léger et performant
- ✅ Tests unitaires implémentés

**Changements majeurs récents** (27 janvier) :
- 🔄 Simplification SQLite → JSON (369 lignes supprimées)
- 🔄 Cache offline des réponses API (6 trains)
- 🔄 Tests unitaires avec mocks
- 🔄 Suppression mock data (API réelle partout)

---

**Document mis à jour le** : 27 janvier 2026
**Auteur** : Nicolas
**Version** : 1.3 (après refactoring cache et tests)
