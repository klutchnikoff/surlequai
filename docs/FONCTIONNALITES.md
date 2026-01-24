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
│   14:12 dans 23 min      │ ← Info prochain
│                          │
│   Paris ⟷ Lyon          │
│   16:30 dans 2h15        │
│                          │
│   Bordeaux ⟷ Toulouse   │
│   --:--                  │ ← Pas d'horaire dispo
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
- Info prochain train pour chaque trajet (aperçu rapide)
- Maximum 10 trajets favoris (pour garder simple)

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

### 3. Modal "Tous les horaires"

#### Déclenchement
Tap sur la zone de direction (ex: "Rennes → Nantes")

#### Affichage (Bottom Sheet)

```
┌─────────────────────────────────────┐
│ ═══                                 │ ← Handle glissant
│                                     │
│ Tous les horaires                   │
│ Rennes → Nantes                     │
│ Vendredi 23 janvier 2026            │
├─────────────────────────────────────┤
│                                     │
│ ⊘ 06:12  Voie 2  Passé              │ ← Grisé + barré
│ ⊘ 07:42  Voie 3  Passé              │
│ ⊘ 08:12  Voie 3  Passé              │
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │ ← Séparateur
│                                     │
│ ▶ 14:12  Voie 3  À l'heure  ◀      │ ← PROCHAIN (highlight)
│   [Barre verte épaisse]             │
│                                     │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                     │
│   14:42  Voie 2                     │ ← Futurs (normaux)
│   15:12  Voie 3                     │
│   15:42  Voie 2                     │
│   16:12  Voie 3  +3 min             │ ← Avec retard
│   16:42  Voie 2  Supprimé           │ ← Rouge
│   17:12  Voie 3                     │
│   ...                               │
│                                     │
└─────────────────────────────────────┘
```

**Comportement** :
- Scroll vertical infini
- Swipe vers le bas pour fermer
- Tap en dehors pour fermer
- Auto-scroll vers le prochain train au démarrage
- Horaires passés grisés et barrés
- Prochain train visuellement distinct (flèches, highlight, barre couleur)

**Données affichées** :
- Heure de départ
- Voie
- État (si retard ou suppression)
- Distinction claire passé/présent/futur

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

### 5. Widget écran d'accueil ⭐⭐ SHOULD-HAVE

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
- Affiche le trajet actif (celui sélectionné dans le drawer)
- Mise à jour toutes les 5-10 minutes (économie batterie)
- Tap sur widget → Ouvre l'app
- Tap sur une direction → Ouvre l'app avec modal horaires de cette direction

**Gestion multi-trajets** :
- Option 1 : Widget affiche le trajet marqué comme "favori principal"
- Option 2 : Un widget par trajet (l'utilisateur en ajoute plusieurs)

**Recommandation** : Option 1 pour v1.0 (simple)

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

### Architecture de stockage

#### 1. Horaires théoriques (cache local SQLite)

**Tables** :

```sql
-- Métadonnées grille horaire
CREATE TABLE timetables (
  id INTEGER PRIMARY KEY,
  version TEXT NOT NULL,           -- "2026-A"
  region TEXT NOT NULL,             -- "bretagne"
  valid_from DATE NOT NULL,         -- "2025-12-15"
  valid_until DATE NOT NULL,        -- "2026-06-14"
  downloaded_at TIMESTAMP NOT NULL,
  file_size_bytes INTEGER
);

-- Départs théoriques
CREATE TABLE departures (
  id INTEGER PRIMARY KEY,
  timetable_id INTEGER NOT NULL,
  from_station_id TEXT NOT NULL,    -- "stop_area:SNCF:87471003"
  from_station_name TEXT NOT NULL,  -- "Rennes"
  to_station_id TEXT NOT NULL,
  to_station_name TEXT NOT NULL,
  departure_time TEXT NOT NULL,     -- "14:12:00"
  arrival_time TEXT NOT NULL,       -- "15:28:00"
  platform TEXT,                    -- "3"
  days_mask TEXT NOT NULL,          -- "1111100" (Lu-Ve)
  FOREIGN KEY (timetable_id) REFERENCES timetables(id)
);

-- Index pour recherches rapides
CREATE INDEX idx_departures_route
ON departures(from_station_id, to_station_id, departure_time);

CREATE INDEX idx_departures_time
ON departures(departure_time);
```

**Stockage** :
- SQLite local (`sqflite` package Flutter)
- Données compressées si possible
- Taille estimée : 10-50 MB par région

#### 2. Trajets favoris (localStorage)

```json
{
  "trips": [
    {
      "id": "trip_uuid_1",
      "stationA": {
        "id": "stop_area:SNCF:87471003",
        "name": "Rennes"
      },
      "stationB": {
        "id": "stop_area:SNCF:87481002",
        "name": "Nantes"
      },
      "active": true,
      "order": 0,
      "createdAt": "2026-01-20T10:30:00Z"
    }
  ],
  "activeTrajetId": "trip_uuid_1"
}
```

#### 3. Settings (localStorage)

```json
{
  "refreshInterval": 60,              // secondes
  "darkMode": "auto",                 // "auto" | "light" | "dark"
  "displayOrder": "auto",             // "auto" | "fixed"
  "displayOrderMorningStart": "06:00",
  "displayOrderEveningStart": "13:00",
  "hapticFeedback": true,
  "notifications": false,
  "notificationMinutesBefore": 10
}
```

### Flux de données au lancement

```
1. App démarre
   ├─ Affiche skeleton/placeholder
   │
2. Charge localStorage (50ms)
   ├─ Trajets favoris
   ├─ Settings
   └─ Trajet actif
   │
3. Charge horaires théoriques depuis SQLite (100ms)
   ├─ Filtre par trajet actif
   ├─ Filtre par heure actuelle (prochains trains)
   └─ Affiche avec état "Horaire prévu" (bleu)
   │
4. Vérifie réseau
   ├─ [Si réseau disponible]
   │  ├─ Vérifie version grille horaire (requête HTTP légère)
   │  │  ├─ Version identique → OK
   │  │  └─ Version différente → Télécharge nouvelle grille
   │  │
   │  └─ Récupère temps réel (API SNCF)
   │     └─ Met à jour affichage (vert/orange/rouge)
   │
   └─ [Si pas de réseau]
      ├─ Affiche bandeau "Hors connexion"
      └─ Reste sur horaires théoriques (bleu)
```

**Objectif temps** :
- Affichage horaires théoriques : < 200ms
- Affichage temps réel : < 1000ms (selon réseau)

### Rafraîchissement automatique

**En mode online** :
```
Toutes les 60 secondes (configurable):
├─ Récupère temps réel via API
├─ Met à jour affichage
└─ Met à jour indicateur "Mis à jour il y a X"
```

**En mode offline** :
```
Toutes les 5 minutes:
├─ Tente de se reconnecter
├─ Si succès → Bascule en mode online
└─ Sinon → Reste en mode offline
```

**Économie batterie** :
- App en arrière-plan → Pas de rafraîchissement
- Écran éteint → Pas de rafraîchissement
- Sauf si widget actif → Rafraîchissement réduit (toutes les 10 min)

### Gestion des versions de grille horaire

#### Détection de nouvelle version

**Endpoint léger** :
```
GET /api/timetable/version?region=bretagne

Response:
{
  "version": "2026-B",
  "valid_from": "2026-06-15",
  "valid_until": "2026-12-14",
  "size_bytes": 15728640,
  "download_url": "https://..."
}
```

**Stratégie** :
1. Au lancement de l'app : Vérifier version
2. Si nouvelle version dispo : Afficher bandeau
3. Utilisateur peut :
   - Télécharger maintenant (WiFi recommandé)
   - Reporter (rappel dans 24h)
   - Ignorer cette version

#### Téléchargement progressif

```
1. Télécharge fichier GTFS ou JSON (10-50 MB)
2. Parse et importe dans SQLite
3. Supprime ancienne version
4. Notifie utilisateur (succès)
```

**Gestion erreurs** :
- Échec téléchargement → Garde ancienne version
- Échec parsing → Rollback vers ancienne version
- Pas d'espace disque → Alerte utilisateur

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
│ Ordre d'affichage                   │
│ ● Auto selon l'heure                │
│ ○ Toujours A→B puis B→A             │
│   [Personnaliser les heures]        │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ DONNÉES                             │
│                                     │
│ Fréquence de rafraîchissement       │
│ [30s] [60s] [● 2min] [5min]        │
│                                     │
│ Grille horaire                      │
│ Version actuelle: 2026-A            │
│ Valide jusqu'au: 14/06/2026         │
│ [Vérifier les mises à jour]         │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ NOTIFICATIONS (optionnel v1.0)      │
│                                     │
│ Alerte départ imminent              │
│ [ ] Activer                         │
│     M'alerter [10] min avant        │
│                                     │
├─────────────────────────────────────┤
│                                     │
│ INTERFACE                           │
│                                     │
│ Retour haptique                     │
│ [✓] Vibrations aux interactions     │
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

#### Notifications (optionnel v1.0)

Si implémenté :
- Désactivé par défaut
- Alerte X minutes avant le départ
- Valeurs : 5, 10, 15, 20 minutes
- Notification silencieuse (vibration uniquement)
- Pas de notification si l'app est ouverte

#### Retour haptique
- Activé par défaut
- Vibrations légères sur interactions (tap, swipe, etc.)
- Désactivable pour ceux qui n'aiment pas

---

## 🔔 Notifications (optionnel v1.0)

### Notification de départ imminent

**Déclenchement** :
- X minutes avant le prochain train du trajet actif
- Uniquement si l'app est en arrière-plan (pas si ouverte)
- Uniquement pour la direction pertinente selon l'heure

**Contenu** :
```
🚂 Train dans 10 min

Rennes → Nantes
14:12 - Voie 3
À l'heure
```

**Actions rapides** (Android) :
- [Voir tous les horaires] → Ouvre app
- [Ignorer]

**Comportement** :
- Vibration uniquement (pas de son)
- Une seule notification (pas de spam)
- Annulée si l'utilisateur ouvre l'app

**Configuration** :
- Opt-in (désactivé par défaut)
- Choix du délai : 5, 10, 15, 20 minutes

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

### API SNCF - Endpoints nécessaires

#### 1. Version grille horaire

```
GET https://proxy.surlequai.app/timetable/version
Query params:
  - region: "bretagne" (optionnel, auto-détecté)

Response:
{
  "version": "2026-A",
  "valid_from": "2025-12-15",
  "valid_until": "2026-06-14",
  "size_bytes": 15728640,
  "download_url": "https://..."
}
```

#### 2. Téléchargement grille

```
GET https://proxy.surlequai.app/timetable/download
Query params:
  - version: "2026-A"
  - region: "bretagne"

Response:
[Binary file: GTFS ZIP ou JSON compressé]
```

#### 3. Temps réel

```
GET https://proxy.surlequai.app/departures/realtime
Query params:
  - from: "stop_area:SNCF:87471003"
  - to: "stop_area:SNCF:87481002"
  - datetime: "2026-01-23T14:00:00Z"
  - count: 10

Response:
{
  "departures": [
    {
      "id": "trip_123456",
      "scheduled_departure": "14:12:00",
      "estimated_departure": "14:15:00",
      "delay_minutes": 3,
      "status": "delayed",  // "on_time" | "delayed" | "canceled"
      "platform": "3",
      "platform_changed": false
    }
  ],
  "last_update": "2026-01-23T13:58:30Z"
}
```

#### 4. Autocomplete gares

```
GET https://proxy.surlequai.app/stations/search
Query params:
  - q: "renn"
  - limit: 10

Response:
{
  "stations": [
    {
      "id": "stop_area:SNCF:87471003",
      "name": "Rennes",
      "type": "station"
    },
    {
      "id": "stop_area:SNCF:87471011",
      "name": "Rennes Pontchaillou",
      "type": "station"
    }
  ]
}
```

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

### Tests fonctionnels à effectuer

#### Données
- [ ] Chargement horaires théoriques depuis SQLite
- [ ] Récupération temps réel depuis API
- [ ] Fusion horaires théoriques + temps réel
- [ ] Gestion perte réseau (passage online → offline)
- [ ] Gestion récupération réseau (passage offline → online)
- [ ] Détection nouvelle version grille horaire
- [ ] Téléchargement et import nouvelle grille

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

## ✅ Checklist finale v1.0

### Must-Have (Priorité absolue)

#### Interface
- [ ] Écran principal avec 2 directions
- [ ] États visuels (vert/orange/rouge/bleu)
- [ ] Bandeau hors connexion
- [ ] Indicateur "Mis à jour il y a X" ⭐⭐⭐
- [ ] État "Aucun train" ⭐⭐⭐
- [ ] Mode sombre + clair
- [ ] Animations transitions ⭐⭐

#### Multi-trajets
- [ ] Drawer latéral
- [ ] Ajout/suppression trajets
- [ ] Info prochain train par trajet
- [ ] Changement trajet actif

#### Modal
- [ ] Modal horaires complets
- [ ] Scroll vers prochain train
- [ ] Horaires passés grisés

#### Données
- [ ] Cache SQLite horaires théoriques
- [ ] API temps réel
- [ ] Mode hors-ligne
- [ ] Détection version grille
- [ ] Rafraîchissement auto

#### Ordre auto ⭐⭐⭐
- [ ] Détection plage horaire
- [ ] Inversion auto matin/soir
- [ ] Configuration personnalisée

#### Gestes
- [ ] Pull-to-refresh
- [ ] Feedback haptique ⭐⭐

### Should-Have (Important mais pas bloquant)

- [ ] Widget écran d'accueil ⭐⭐
- [ ] Notifications départ imminent (opt-in)

### Nice-to-Have (Bonus si temps)

- [ ] Shake to refresh
- [ ] Mode tablette/paysage

---

## 🚀 Prochaines étapes immédiates

1. **Setup projet Flutter**
   - Créer projet
   - Configurer dépendances
   - Structure de dossiers

2. **Tests API SNCF**
   - Créer compte API
   - Obtenir clé
   - Tester endpoints
   - Identifier codes gares

3. **Déployer proxy Cloudflare**
   - Setup Worker
   - Implémenter endpoints
   - Tester rate limiting

4. **Prototyper UI**
   - Écran principal (mock data)
   - Drawer
   - Modal
   - Valider gestes

5. **Implémenter cache**
   - Setup SQLite
   - Import grille horaire
   - Requêtes optimisées

---

**Document à jour au** : 23 janvier 2026
**Auteur** : Nicolas
**Version** : 1.0
