# SurLeQuai - Projet d'application TER quotidienne

**Date de création** : 23 janvier 2026
**Statut** : Phase de conception
**Version cible** : 1.0 MVP

---

## 🎯 Vision du projet

### Problème résolu
Les voyageurs quotidiens TER (domicile ⟷ travail) doivent consulter plusieurs apps/sites pour voir simplement les prochains trains dans les deux sens. Il manque une application **minimaliste** qui affiche en permanence :
- Les prochains trains A → B
- Les prochains trains B → A
- Sans création de compte
- Sans complexité inutile

### Proposition de valeur
**Une seule chose, mais bien** : afficher les horaires temps réel des prochains trains entre deux gares, dans les deux sens, de façon ultra-lisible.

---

## 📱 Nom et identité

### Nom : **SurLeQuai**

**Raisons du choix** :
- Évocateur et poétique
- Pas de conflit avec marques SNCF (pas de "TER")
- Disponible (domaines, packages)
- Universel (extensible bus/métro)
- Tag line : *"Vos prochains trains, directement sur le quai"*

**Noms écartés** :
- ❌ TrainTrain (domaine squatté, café à Lausanne)
- ❌ MonTER, QuoTERdien (risque marque SNCF)
- ❌ Terminal (trop générique)

---

## 🎨 Logo

### Concept
**Horloge de gare à cadran avec aiguilles**, format carré/rectangulaire (pas circulaire pour se différencier des horloges SNCF classiques).

### Design
- **Forme** : Carré aux coins légèrement arrondis (R=10-15%)
- **Cadran** : Blanc cassé (#FAFAFA)
- **Chiffres** : Noir, positions 12, 3, 6, 9 (style DIN ou Helvetica)
- **Aiguilles** : Noires, fines et élégantes (style gare SNCF)
- **Position** : Aiguilles figées sur **16:50** (4h50 sur cadran 12h)
- **Cadre** : Noir fin

### Easter egg
**16:50** est une référence au roman d'Agatha Christie *"Le Train de 16h50"* (*4:50 from Paddington*, 1957) avec Miss Marple.

### Placement du nom
Texte "SurLeQuai" en petites capitales à la position 6h du cadran, ou sous le logo selon le contexte.

---

## 🏗️ Architecture technique

### Stack retenue

**Application** :
- **Flutter** (Android + iOS, code unique)
- Mode portrait uniquement (v1.0)
- Mode sombre + mode clair (dès v1.0)

**Backend/Proxy** :
- **Cloudflare Workers** (serverless gratuit)
- Proxy pour sécuriser la clé API SNCF
- Rate limiting par IP

**API de données** :
- **API SNCF** (https://numerique.sncf.com/startup/api/)
- Quota gratuit : 150 000 req/mois (5 000/jour)
- Format : JSON (endpoints `/departures`)

### Architecture flux de données

```
┌─────────────────┐
│  App Flutter    │
│  (utilisateur)  │
└────────┬────────┘
         │ HTTPS
         ▼
┌─────────────────┐
│ Cloudflare      │ ← UNE clé API pour tous
│ Workers (proxy) │   Rate limiting
└────────┬────────┘
         │ Auth
         ▼
┌─────────────────┐
│   API SNCF      │
│   Temps réel    │
└─────────────────┘
```

### Sécurité et scalabilité
- Clé API dans le Worker (pas dans l'app)
- Rate limiting : ~100 req/heure par IP
- Capacité : ~40 utilisateurs actifs simultanés avec une seule clé gratuite
- Évolution : Pool de clés communautaires ou clé perso optionnelle

---

## 🎨 Design de l'interface

### Écran unique

```
┌─────────────────────────────────────┐
│    SurLeQuai    13:42          [⚙️] │ ← Header
└─────────────────────────────────────┘
│                                     │
│   Rennes → Nantes              ⟲    │ ← Tap pour modifier
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │ ← Barre couleur (état)
│                                     │
│        14:12      Voie 3            │ ← PROCHAIN TRAIN
│        À l'heure                    │   (énorme, évident)
│                                     │
│   Puis: 14:42  15:12                │ ← Suivants (1 ligne)
│                                     │
├─────────────────────────────────────┤
│                                     │
│   Nantes → Rennes              ⟲    │
│   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━    │
│                                     │
│        14:27      Voie 1            │
│        +5 min                        │
│                                     │
│   Puis: 14:57  15:27                │
│                                     │
└─────────────────────────────────────┘
  ↑ Pull-to-refresh
```

### Codes couleur (états des trains)

| État | Barre | Texte | Couleur | Hex |
|------|-------|-------|---------|-----|
| **À l'heure** | Épaisse verte | "À l'heure" en vert | Vert | `#22C55E` |
| **Retardé** | Épaisse orange | "+X min" en orange | Orange | `#F59E0B` |
| **Supprimé** | Épaisse rouge | "Supprimé" en rouge | Rouge | `#EF4444` |
| **Suivants** | - | Horaires en gris | Gris | `#9CA3AF` |

### Règles visuelles

**Prochain train** :
- Heure : Très grande (taille dominante)
- Voie : Grande (lisible d'un coup d'œil)
- État : Couleur + texte cohérent
- 90% de l'attention visuelle

**Trains suivants** :
- Une seule ligne : `Puis: 14:42  15:12`
- Petite taille, gris discret
- 10% de l'attention visuelle

**Principes de design** :
- ✅ Pas de cadres lourds
- ✅ Beaucoup d'espace blanc
- ✅ Barre de couleur = séparateur + indicateur
- ✅ Hiérarchie visuelle claire
- ✅ Lisibilité maximale

---

## 🖱️ Interactions et gestes

### Gestes principaux

| Geste | Action | Zone |
|-------|--------|------|
| **Swipe ← →** | Inverse A ⟷ B | N'importe où sur l'écran |
| **Pull-to-refresh ↓** | Force rafraîchissement | Depuis le haut |
| **Tap sur gare** | Ouvre sélecteur de gare | Nom de gare |
| **Tap sur ⚙️** | Ouvre Settings | Icône settings |

### Feedback visuel

**Rafraîchissement** :
- Indicateur spinner discret en haut
- Texte "Mis à jour il y a X min"

**Erreur réseau** :
- Toast/Snackbar rouge en bas
- Message : "Impossible de charger les horaires"

**Pas de notifications** :
- Pas de son
- Pas de vibration
- Tout visuel uniquement

---

## ⚙️ Fonctionnalités

### Version 1.0 (MVP)

**Écran principal** :
- ✅ Affichage 2 directions (A→B et B→A)
- ✅ 1 prochain train (grand, coloré)
- ✅ 2 trains suivants (petits, gris, une ligne)
- ✅ État temps réel : à l'heure / retard / supprimé
- ✅ Rafraîchissement auto (60 sec)
- ✅ Pull-to-refresh manuel
- ✅ Swipe pour inverser A ⟷ B

**Données affichées par train** :
- ✅ Heure de départ
- ✅ Voie/Quai
- ✅ État (à l'heure / +X min / supprimé)
- ❌ Pas d'heure d'arrivée
- ❌ Pas de durée de trajet
- ❌ Pas de numéro de train

**Configuration** :
- ✅ Sélection Gare A
- ✅ Sélection Gare B
- ✅ Stockage local (localStorage)
- ❌ Pas de création de compte

**Settings** :
- ✅ Fréquence de rafraîchissement
- ✅ Mode sombre / clair
- ✅ À propos (easter egg 16:50)
- ✅ Lien vers dépôt GitHub

### Fonctionnalités exclues de la v1.0

Pour garder la **simplicité maximale** :
- ❌ Notifications push
- ❌ Alertes sonores
- ❌ Favoris multiples (plusieurs paires de gares)
- ❌ Historique des trajets
- ❌ Partage de l'horaire
- ❌ Widget écran d'accueil (peut-être v2.0)
- ❌ Mode paysage

---

## 🚀 Feuille de route

### Phase 1 : Préparation (🔄 en cours)
- [x] Définir le concept
- [x] Choisir le nom
- [x] Concevoir le logo
- [x] Designer l'interface
- [ ] Créer compte API SNCF
- [ ] Obtenir clé API
- [ ] Identifier codes gares (stop_area)
- [ ] Tester endpoints API

### Phase 2 : Prototypage
- [ ] Setup projet Flutter
- [ ] Maquette UI (écran unique)
- [ ] Mock data (horaires fictifs)
- [ ] Valider navigation et gestes

### Phase 3 : Backend
- [ ] Déployer Cloudflare Worker
- [ ] Implémenter proxy API SNCF
- [ ] Ajouter rate limiting
- [ ] Tester avec données réelles

### Phase 4 : Développement app
- [ ] Service API (appels HTTP)
- [ ] Parser réponses JSON
- [ ] State management (Provider/Riverpod)
- [ ] Écran principal fonctionnel
- [ ] Sélecteur de gares
- [ ] Settings
- [ ] Mode sombre

### Phase 5 : Tests
- [ ] Tests utilisateurs (alpha privée)
- [ ] Monitoring quota API
- [ ] Corrections bugs
- [ ] Optimisations

### Phase 6 : Distribution
- [ ] Open source (GitHub)
- [ ] Licence GPL/MIT
- [ ] README complet
- [ ] F-Droid (Android open source)
- [ ] GitHub Releases (APK direct)
- [ ] Google Play (optionnel, 25$ one-time)
- [ ] Communication (LinuxFR, forums SNCF)

---

## 📊 Stratégie de distribution

### Open Source dès le début
- **GitHub public**
- **Licence** : GPL v3 ou MIT (à décider)
- **Issues** pour bugs/features
- **Documentation claire** (FR + EN)

### Canaux de distribution

| Canal | Priorité | Coût | Public |
|-------|----------|------|--------|
| **F-Droid** | ⭐⭐⭐ | Gratuit | Android open source |
| **GitHub Releases** | ⭐⭐⭐ | Gratuit | APK direct |
| **Google Play** | ⭐⭐ | 25$ one-time | Grand public Android |
| **App Store iOS** | ⭐ | 99$/an | iOS (si budget) |

### Communication
- Post LinuxFR, Framasoft
- Communautés transport (carto.tchoo.net)
- Forum SNCF Open Data
- Reddit /r/france, /r/opensource

---

## 🎯 Valeurs du projet

### Principes fondateurs
1. **Une seule chose, bien faite** : Afficher les prochains trains, point.
2. **Simplicité maximale** : Zéro friction, zéro complexité
3. **Respect de l'utilisateur** :
   - Pas de compte obligatoire
   - Pas de pub
   - Pas de tracking
   - Open source
4. **Souveraineté des données** : Tout en local
5. **Accessibilité** : Gratuit pour tous

### Modèle économique
**Phase 1-2** : Bénévolat, infrastructure gratuite
**Phase 3** (si forte croissance) :
- Dons optionnels (Liberapay/Ko-fi)
- OU demande quota augmenté SNCF (partenariat)
- OU clés API contributives (pool communautaire)

---

## 📋 Aspects légaux

### Conditions SNCF à respecter
- ✅ Quota API (rate limiting)
- ✅ Pas de revente de données
- ✅ Mention source SNCF
- ✅ RGPD (pas de données perso stockées)

### Propriété intellectuelle
- ✅ "TER" est une marque SNCF → évitée
- ✅ "SurLeQuai" → pas de conflit trouvé
- ✅ Logo original (pas de copie SNCF)

---

## 🔧 Structure du projet

### Arborescence prévue

```
surlequai/
├── app/                      # Application Flutter
│   ├── lib/
│   │   ├── models/
│   │   │   ├── train.dart
│   │   │   ├── departure.dart
│   │   │   └── station.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   └── storage_service.dart
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── station_picker_screen.dart
│   │   ├── widgets/
│   │   │   ├── direction_card.dart
│   │   │   ├── train_info.dart
│   │   │   └── status_bar.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── colors.dart
│   │   └── main.dart
│   └── pubspec.yaml
│
├── proxy/                    # Cloudflare Worker
│   ├── index.js
│   ├── wrangler.toml
│   └── README.md
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── API.md
│   ├── CONTRIBUTING.md
│   └── DESIGN.md
│
├── assets/
│   ├── logo/
│   │   ├── logo.svg
│   │   ├── logo-512.png
│   │   └── logo-1024.png
│   └── screenshots/
│
├── README.md
├── LICENSE
└── CHANGELOG.md
```

---

## 📝 Notes techniques importantes

### API SNCF - Points clés
- **Endpoint principal** : `/coverage/sncf/stop_areas/{stop_id}/departures`
- **Authentification** : HTTP Basic (clé API en username, pas de password)
- **Format** : JSON
- **Rate limit** : 20 req/min pour temps réel Transilien, sinon quota journalier
- **Données disponibles** :
  - Horaires théoriques
  - Horaires temps réel
  - Retards
  - Suppressions
  - Voies/quais
  - Perturbations

### Identification des gares
- Chaque gare a un `stop_area_id` (ex: `stop_area:SNCF:87471003` pour Rennes)
- Format : `stop_area:SNCF:XXXXXXXX` (code UIC)
- Autocomplete disponible via l'API

### Parsing des réponses
Les trains supprimés peuvent :
- Avoir un flag `deleted: true`
- OU être absents de la réponse
- ⚠️ Gérer les deux cas

---

## 🎨 Palette de couleurs complète

### Couleurs principales

```css
/* États des trains */
--color-on-time: #22C55E;      /* Vert - À l'heure */
--color-delayed: #F59E0B;      /* Orange - Retard */
--color-canceled: #EF4444;     /* Rouge - Supprimé */
--color-secondary: #9CA3AF;    /* Gris - Horaires suivants */

/* Interface */
--color-background-light: #FFFFFF;
--color-background-dark: #1F2937;
--color-text-light: #111827;
--color-text-dark: #F9FAFB;
--color-border: #E5E7EB;

/* Accents */
--color-primary: #3B82F6;      /* Bleu - éléments interactifs */
```

### Typographie

**Familles de polices** :
- **Titres/Heures** : DIN Bold ou Helvetica Neue Bold
- **Corps** : Roboto ou SF Pro (système)
- **Monospace** : Roboto Mono (horaires secondaires)

**Tailles** :
- Heure prochain train : 48-56px
- Voie : 24-28px
- État : 20-24px
- Horaires suivants : 16-18px
- Textes secondaires : 14px

---

## 🧪 Tests à effectuer

### Phase API
- [ ] Connexion à l'API avec clé
- [ ] Récupération horaires gare A
- [ ] Récupération horaires gare B
- [ ] Parsing données temps réel
- [ ] Gestion erreurs réseau
- [ ] Gestion quota dépassé

### Phase UI/UX
- [ ] Lisibilité sur différentes tailles d'écran
- [ ] Swipe fluide et intuitif
- [ ] Pull-to-refresh responsive
- [ ] Transitions d'état (vert → orange → rouge)
- [ ] Mode sombre cohérent
- [ ] Performance (60 fps)

### Phase utilisateur
- [ ] Compréhension immédiate (premier lancement)
- [ ] Utilisation quotidienne (fiabilité)
- [ ] Temps de chargement acceptable
- [ ] Consommation batterie raisonnable

---

## 💡 Idées pour versions futures (v2.0+)

### Extensions possibles
- Widget écran d'accueil (Android/iOS)
- Support tablette + mode paysage
- Favoris multiples (plusieurs paires de gares)
- Notifications intelligentes (avant départ)
- Support autres modes (bus, métro, tramway)
- Export iCal/Google Calendar
- Partage d'itinéraire
- Mode hors-ligne avec cache
- Statistiques de ponctualité

### Extensions communautaires
- Intégration avec d'autres apps (Fairtiq, etc.)
- API publique pour développeurs
- Plugins/extensions

**Principe** : Chaque ajout doit être justifié par un besoin réel, pas par "c'est techniquement possible".

---

## 📞 Contacts et ressources

### Ressources techniques
- **API SNCF** : https://numerique.sncf.com/startup/api/
- **Documentation** : https://doc.navitia.io/
- **SNCF Open Data** : https://ressources.data.sncf.com/
- **Cloudflare Workers** : https://workers.cloudflare.com/

### Communautés
- **Carto Tchoo** : https://carto.tchoo.net/ (passionnés transport)
- **Forum transport.data.gouv.fr** : discussions Open Data
- **LinuxFR** : annonces projets libres

### Inspirations
- *Le Train de 16h50*, Agatha Christie (1957)
- Applications de référence : Citymapper, Trainline
- Design : horloges de gare françaises, panneaux SNCF

---

## 📅 Changelog du projet

### 2026-01-23 - Conception initiale
- ✅ Définition du concept
- ✅ Choix du nom "SurLeQuai"
- ✅ Design du logo (horloge 16:50)
- ✅ Maquette UI complète
- ✅ Architecture technique validée
- 📝 Rédaction de ce document

---

## ✅ Prochaines actions immédiates

1. **Créer compte API SNCF** (https://numerique.sncf.com/startup/api/)
2. **Obtenir clé API** (gratuite, instantané)
3. **Identifier codes gares** pour tests (Rennes, Nantes, etc.)
4. **Premier appel API** pour valider les données
5. **Setup projet Flutter** (structure de base)

---

*Document vivant - À mettre à jour au fur et à mesure de l'avancement du projet*

**Auteur** : Nicolas  Klutchnikoff
**Dernière mise à jour** : 23 janvier 2026
**Version** : 1.0
