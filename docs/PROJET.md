# SurLeQuai - Projet d'application TER quotidienne

**Date de création** : 23 janvier 2026
**Statut** : Phase de conception
**Version cible** : 1.0 MVP

> [!NOTE]
> Ce document décrit la vision globale, l'architecture et la feuille de route du projet.
> Pour une description détaillée des fonctionnalités, de l'interface et des spécifications techniques, voir [docs/FONCTIONNALITES.md](./FONCTIONNALITES.md).

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

Le design détaillé de l'interface, les maquettes et les flux d'interaction sont spécifiés dans le document [docs/FONCTIONNALITES.md](./FONCTIONNALITES.md).

---

## ⚙️ Fonctionnalités

Pour une liste exhaustive et détaillée, se référer au document [docs/FONCTIONNALITES.md](./FONCTIONNALITES.md).

### Version 1.0 (MVP)

**Écran principal** :
- ✅ Affichage 2 directions (A→B et B→A)
- ✅ 1 prochain train (grand, coloré)
- ✅ 2 trains suivants (petits, gris, une ligne)
- ✅ État temps réel : à l'heure / retard / supprimé
- ✅ Rafraîchissement auto (60 sec)
- ✅ Pull-to-refresh manuel
- ✅ Ordre automatique matin/soir (configurable)

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
1. **Une seule thing, bien faite** : Afficher les prochains trains, point.
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

*Document vivant - À mettre à jour au fur et à mesure de l'avancement du projet*

**Auteur** : Nicolas  Klutchnikoff
**Dernière mise à jour** : 23 janvier 2026
**Version** : 1.0