---
layout: default
title: Architecture Technique
---

# Architecture Technique de SurLeQuai

Ce document décrit les choix techniques, l'architecture logicielle et les patterns utilisés dans le projet **SurLeQuai**.

## 🏗 Vue d'ensemble

SurLeQuai est une application Flutter (iOS/Android) conçue pour la rapidité et la robustesse. Elle s'appuie sur une architecture en couches claire :

1.  **UI (Flutter & Widgets Natifs)** : Affichage des données.
2.  **State Management (Provider)** : Gestion de l'état applicatif.
3.  **Domain (Models)** : Objets métiers immuables (Freezed).
4.  **Data (Services)** : Accès API et persistance.
5.  **Backend (Proxy)** : Cloudflare Worker pour la sécurité.

## 🛠 Stack Technique

*   **Framework** : Flutter 3.x
*   **Langage** : Dart
*   **State Management** : `provider` (Simple, efficace pour l'injection de dépendance).
*   **Modélisation** : `freezed` + `json_serializable` (Immuabilité, parsing JSON sécurisé, Unions).
*   **API Client** : `http` avec une couche d'abstraction custom.
*   **Widgets Natifs** : `home_widget` pour le pont Dart <-> Kotlin/Swift.
*   **Backend** : Cloudflare Worker (JavaScript) pour l'injection de clé API et le rate-limiting.

## 🧠 Concepts Clés

### 1. Logique Partagée (Le "Cerveau")

L'un des défis majeurs était de synchroniser l'affichage de l'application Flutter et des Widgets natifs (iOS/Android).
Nous avons résolu cela via le pattern **Shared ViewModel**.

*   **`DirectionCardViewModel`** : Une classe scellée (`sealed class`) qui contient toute la logique d'affichage :
    *   Quel train afficher (le prochain, ou celui de demain matin ?)
    *   Quelle couleur utiliser (Vert = à l'heure, Orange = retard) ?
    *   Quel texte afficher ("À l'heure", "+5 min") ?
*   **Utilisation** :
    *   L'App Flutter l'utilise pour rendre les cartes (`DirectionCard`).
    *   Le `WidgetService` l'utilise pour préparer les données brutes (`String`) envoyées au code natif.

**Gain** : Zéro duplication de logique. Si on change la règle d'affichage d'un retard, l'app et les widgets sont mis à jour simultanément.

### 2. Robustesse des Données

Nous utilisons **Freezed** pour tous les modèles :
*   **DTOs (`lib/models/navitia/`)** : Modèles miroirs de l'API Navitia. Parsing strict et sécurisé.
*   **Domain (`lib/models/`)** : `Trip`, `Station`, `Departure`. Immuables avec `copyWith`.

### 3. Gestion de l'API (Bon Citoyen)

L'application respecte les quotas de l'API Navitia/SNCF grâce à une stratégie de **Throttling** dans `TripProvider` :
*   **Au lancement / Navigation** : Seul le trajet actif est mis à jour (1 appel).
*   **En arrière-plan** : Les autres trajets ne sont mis à jour que si le cache a plus de 5 minutes.
*   **Pull-to-refresh** : Force la mise à jour de tous les trajets (Action utilisateur explicite).

### 4. Sécurité (Proxy)

Les clés API ne sont **jamais** stockées dans l'application compilée.
*   L'app appelle un Proxy Cloudflare (`worker.js`).
*   Le Proxy injecte la clé API secrète et transfère la requête à Navitia.
*   Exceptions : Mode "BYOK" (Bring Your Own Key) où l'utilisateur peut saisir sa propre clé, stockée dans le `FlutterSecureStorage`.

## 📂 Structure du Code

```
lib/
├── models/          # Objets métiers (Freezed)
│   └── navitia/     # DTOs de l'API Navitia
├── screens/         # Écrans Flutter (Scaffold)
├── services/        # Logique métier (API, Stockage, Calculs)
│   ├── api_service.dart    # Client HTTP centralisé
│   ├── trip_provider.dart  # State Management & Orchestration
│   └── widget_service.dart # Pont vers iOS/Android
├── widgets/         # Composants UI réutilisables
│   └── direction_card.dart # La carte principale
└── utils/           # Constantes et Helpers
```

## 🧪 Tests

La qualité est assurée par une suite de tests unitaires :
*   **API** : Tests avec mock HTTP pour valider le parsing et les erreurs 401/404.
*   **Logic** : Tests exhaustifs de `DirectionCardViewModel` (injection de temps pour tester les cas "demain", "retard").
*   **Services** : Tests de `WidgetService` avec mock des Platform Channels.

---
*Dernière mise à jour : Janvier 2026*
