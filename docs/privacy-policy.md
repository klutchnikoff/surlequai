# Politique de confidentialité - SurLeQuai

**Date de dernière mise à jour : 28 janvier 2026**

## Introduction

SurLeQuai est une application gratuite développée par Nicolas Klutchnikoff. Cette politique de confidentialité explique comment l'application traite vos données.

## Collecte de données

**SurLeQuai ne collecte AUCUNE donnée personnelle.**

L'application fonctionne entièrement en local sur votre appareil. Aucune information n'est transmise à des serveurs tiers, sauf celles strictement nécessaires au fonctionnement de l'application (voir section "Données transmises" ci-dessous).

## Données stockées localement

Les données suivantes sont stockées **uniquement sur votre appareil** :

- **Trajets favoris** : Les paires de gares que vous configurez (exemple : Rennes ↔ Nantes)
- **Préférences** : Vos paramètres d'affichage (thème clair/sombre, heures de transition jour/soir)
- **Clé API SNCF** (optionnel) : Si vous choisissez le mode BYOK (Bring Your Own Key), votre clé est stockée de manière sécurisée dans le trousseau Android (KeyStore) ou iOS (Keychain)
- **Cache horaires** : Les horaires récents sont mis en cache pour permettre une consultation hors ligne

**Aucune de ces données n'est accessible par le développeur ou transmise à des tiers.**

## Données transmises

Pour fonctionner, SurLeQuai doit récupérer les horaires de trains auprès de la SNCF. Voici ce qui est transmis :

### Mode proxy (par défaut)

Par défaut, l'application utilise un proxy anonyme (`surlequai.nicolas-klutchnikoff.workers.dev`) pour interroger l'API SNCF. Ce proxy :

- **Masque votre adresse IP** à la SNCF
- **Ne conserve aucun log** des requêtes
- **Ne collecte aucune donnée personnelle**
- Transmet uniquement les informations strictement nécessaires : identifiants des gares et horaires demandés

Le code source du proxy est disponible publiquement et peut être audité.

### Mode BYOK (Bring Your Own Key)

Si vous choisissez d'utiliser votre propre clé API SNCF (mode avancé), l'application contacte directement l'API SNCF (api.sncf.com). Dans ce cas :

- Votre adresse IP est visible par la SNCF
- Les données transmises sont régies par la [politique de confidentialité de la SNCF](https://www.sncf.com/fr/politique-de-confidentialite)
- Le développeur de SurLeQuai n'a aucun accès à ces données

## Services tiers

### API SNCF (Navitia.io)

L'application utilise l'API publique SNCF (Navitia.io) pour obtenir les horaires de trains. Les données fournies par cette API sont des **données ouvertes** (licence ouverte Etalab 2.0).

Politique de confidentialité SNCF : https://www.sncf.com/fr/politique-de-confidentialite

### Google Play Services (Android uniquement)

Si vous avez installé SurLeQuai depuis le Google Play Store, les politiques de Google s'appliquent :
- [Politique de confidentialité Google Play](https://policies.google.com/privacy)

L'application elle-même n'utilise aucun service Google (Firebase, Analytics, Ads, etc.).

## Widgets Android

Si vous ajoutez le widget SurLeQuai sur votre écran d'accueil Android, les données affichées sur le widget proviennent du cache local de l'application. Aucune donnée n'est transmise à des tiers via le widget.

## Cookies et trackers

**SurLeQuai n'utilise AUCUN cookie, tracker ou outil d'analyse.**

L'application ne contient pas de code de suivi, pas de publicité, et ne transmet aucune donnée d'usage (analytics) au développeur.

## Sécurité des données

- Les données sont stockées localement sur votre appareil
- La clé API SNCF (si configurée) est chiffrée via le trousseau sécurisé de votre système d'exploitation
- Les communications avec l'API SNCF utilisent le protocole HTTPS (chiffrement en transit)

## Vos droits

Conformément au RGPD (Règlement Général sur la Protection des Données), vous disposez des droits suivants :

- **Droit d'accès** : Toutes vos données sont stockées localement sur votre appareil, vous y avez donc un accès direct
- **Droit de suppression** : Vous pouvez supprimer toutes vos données en désinstallant l'application ou en vidant le cache dans les paramètres
- **Droit de rectification** : Vous pouvez modifier vos trajets et préférences directement dans l'application

**Aucune demande auprès du développeur n'est nécessaire**, car aucune donnée personnelle n'est collectée ou stockée en dehors de votre appareil.

## Logiciel libre

SurLeQuai est un logiciel libre distribué sous licence MIT. Le code source est disponible publiquement sur GitHub :

**Dépôt GitHub** : https://github.com/klutchnikoff/surlequai

Vous pouvez auditer le code source pour vérifier que cette politique de confidentialité est respectée.

## Modifications de cette politique

Cette politique de confidentialité peut être mise à jour occasionnellement. Toute modification sera publiée sur cette page avec une nouvelle date de mise à jour.

Les modifications substantielles seront annoncées via les notes de version de l'application sur le Play Store.

## Contact

Pour toute question concernant cette politique de confidentialité, vous pouvez contacter le développeur :

**Email** : nicolas.klutchnikoff@gmail.com
**GitHub** : https://github.com/klutchnikoff/surlequai/issues

---

**En résumé** :
- ✅ Aucune donnée personnelle collectée
- ✅ Aucune publicité
- ✅ Aucun tracker
- ✅ Toutes vos données restent sur votre appareil
- ✅ Code source ouvert et auditable
- ✅ Proxy anonyme par défaut (optionnel BYOK pour faire confiance directement à la SNCF)

Dernière mise à jour : 28 janvier 2026
Version de l'application : 0.10.0
