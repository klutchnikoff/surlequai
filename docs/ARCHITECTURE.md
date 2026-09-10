---
layout: default
title: Architecture Technique
---

# Architecture technique de SurLeQuai

## Données et affichage

`ApiService` interroge Navitia et transforme ses réponses en modèles Freezed.
`Departure.scheduledTime` est l'heure théorique ; `effectiveTime` applique le retard
une seule fois. Les annulations signalées par `NO_SERVICE` restent distinctes.

`RealtimeService` retourne un `DeparturesResult` contenant les départs, la date de
réception et leur provenance réseau/cache. Une réponse réseau vide est valide et
remplace le cache précédent. En cas d'échec, les horaires locaux sont affichés en
mode hors ligne, sans conserver une ancienne voie ou un retard comme information
actuelle. La dernière alerte de retard ou de suppression reste explicitement
identifiée comme ancienne. La date de réception ne change pas lors de cette relecture.

`StorageService` conserve les derniers départs par direction dans des fichiers
JSON écrits par remplacement atomique. Le cache version 3 expire après 48 heures ;
les anciens fichiers sont ignorés pour ne pas réintroduire des transports non filtrés ou des cars non identifiés.
Ce cache n'est pas un calendrier ferroviaire complet.

Les fiches horaires théoriques utilisent un cache séparé dans SharedPreferences.
Sa clé inclut le début de journée de service choisi dans les paramètres. `ServiceDay`
calcule les limites en jours civils, y compris lors des changements d'heure.
L'action « vider le cache » nettoie les deux caches et les données affichées.

## État et concurrence

`TripProvider.ready` rend les favoris et le cache disponibles sans attendre le
réseau. Le trajet actif est mémorisé. Chaque requête capture son trajet, et les
requêtes simultanées sur le même trajet sont regroupées. Une réponse tardive ne
remplace pas les données du nouveau trajet sélectionné.

Les listes métier restent toujours A→B et B→A. `DirectionCardViewModel` et
`WidgetService` appliquent l'ordre matin/soir à l'affichage seulement.

Au premier plan, l'affichage est recalculé toutes les 15 secondes. Les appels
réseau ont lieu toutes les 60 secondes, ou toutes les 5 minutes après un échec,
et à la reprise de l'application. Une actualisation requiert deux appels par
trajet, un par direction. Les autres favoris sont actualisés au plus toutes les
5 minutes, sauf demande manuelle. Le timer est suspendu en arrière-plan.

## Widgets

Le ViewModel Dart prépare les textes et statuts communs aux deux plateformes.
Les publications du provider sont sérialisées. Le callback de fond relit les
favoris avant de publier pour détecter une modification pendant la requête.

- **Android** : données partagées via `home_widget`, ouverture du bon favori même
  au démarrage à froid. WorkManager programme une actualisation à partir d'une
  date complète, avec repli à 30 minutes sans départ connu et relance périodique de
  secours. Android peut différer ces travaux selon les contraintes d'énergie.
- **iOS 17+** : extension WidgetKit configurable par favori, formats petit et moyen.
  Un instantané JSON contient les étapes d'affichage aux passages de trains et
  changements de journée. Lorsque l’échéance de rafraîchissement est dépassée, l’instantané affiche les informations
  comme hors ligne. Le widget ne fait pas d'appel SNCF autonome : ouvrir l'app
  renouvelle ses données. iOS contrôle les heures réelles de rafraîchissement.

Runner et l'extension partagent l'App Group `group.com.surlequai.app`. Pour un
appareil réel, il faut activer cet identifiant dans le compte Apple et dans les
profils de signature des deux cibles.

## Proxy

Le Worker injecte le secret SNCF, filtre les routes et construit explicitement
les en-têtes transmis. Son limiteur natif Cloudflare remplace l'ancien compteur
KV. Voir [la documentation du proxy](../cloudflare-worker/README.md) pour sa
configuration et les limites de cette protection. BYOK utilise une clé locale
conservée dans `flutter_secure_storage` et contacte SNCF directement.

## Développement et vérifications

La chaîne de génération utilise Flutter 3.47 / Dart 3.13 et Freezed 4.
Java 21 est compatible avec le Gradle Android actuel (8.14). AndroidX Glance est
fixé à 1.1.1 dans le projet pour éviter la sélection d’une version alpha par la
dépendance dynamique de `home_widget 0.9`. Les coroutines sont fixées à 1.10.2 et
WorkManager à 2.9.0 pour stabiliser également les deux autres dépendances
dynamiques du plugin. WorkManager reste compatible avec sa cible Java 8.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
npm --prefix cloudflare-worker test
flutter build apk --debug
flutter build ios --simulator --debug
```

Les tests couvrent le parsing API, les retards et annulations, le repli hors ligne,
l'âge du cache, les changements de trajet pendant une requête, le passage du temps,
les écritures des widgets et la fermeture des écrans pendant un chargement.
Les tests natifs sur appareil restent nécessaires pour la signature iOS, la
configuration des widgets et les contraintes de rafraîchissement du système.

## Contrat des données (branche de fiabilisation)

- Une réponse récente demandée en temps réel, sans retard ni suppression
  connus, reste affichée « À l’heure », même si Navitia renvoie `base_schedule`.
  Un écart horaire explicite prime sur ce marqueur de fraîcheur.
- `JourneyMapper` conserve une seule section de transport public desservant
  exactement les deux gares demandées. Les raccordements Navitia gare/quai de
  durée nulle sont acceptés ; les parcours à pied et les correspondances sont exclus.
- TER/Intercités et cars avec transporteur ou identifiant de circulation SNCF
  sont admis. Les cars portent la mention « Car » dans l’application, les fiches
  et les widgets. L’API ne permet pas toujours de distinguer un car régulier
  d’un car de substitution : aucune qualification « substitution » n’est inventée.
  Les préférences globales permettent les TGV INOUI/OUIGO (désactivés par défaut)
  et les cars SNCF (activés par défaut). Les modes urbains, Transilien et OUIGO
  Train Classique restent exclus. Les exclusions sont transmises à Navitia avant
  le calcul, puis appliquées au mapping. Les TGV portent la mention « TGV ».
- Les perturbations `NO_SERVICE` explicitement liées à la section, dans leur
  période d’application, sont exploitées. Une disparition de la réponse temps
  réel ne constitue jamais à elle seule une preuve de suppression. Il n’y a pas
  de second appel systématique aux horaires théoriques : certains trains supprimés
  peuvent donc rester absents de cette liste. C’est une limite du périmètre actuel.
- Une réponse mal formée provoque un repli sur le cache, jamais sa suppression.
  Une liste vide valide et l’erreur Navitia `no_solution` sont des résultats vides.
  L’interface distingue ces résultats des horaires indisponibles localement.
- Les erreurs d’authentification, quota, service, délai et données illisibles
  restent accessibles par direction. Après un HTTP 429, `Retry-After` numérique
  est respecté par l’instance API (60 secondes par défaut), y compris pour une
  nouvelle demande manuelle. Ce mécanisme ne coordonne pas plusieurs processus.
- Le cache théorique v4 inclut les choix de transport dans sa clé. Le cache
  des départs v3 utilise des fichiers distincts pour chaque combinaison. Les
  favoris sont conservés.
- Les widgets consomment le même instantané daté. Chaque sens expire selon sa
  propre date ; Android relit la frame courante lors du rendu et avant une
  tentative réseau du Worker. L’OS peut retarder ces réveils : aucune échéance
  d’affichage à la seconde près n’est garantie. iOS ne réclame plus une timeline
  chaque minute lorsqu’une échéance publiée est déjà passée.

Les dates compactes sont validées (une date civile impossible est rejetée), et
le prochain matin du budget de rafraîchissement est calculé en jours civils.
Le traitement complet d’un téléphone réglé sur un fuseau autre que celui du réseau
reste à réaliser ; cette branche ne prétend pas résoudre ce cas.

Une réponse réelle Bruz → Rennes, réduite aux champs utiles, est conservée dans
`test/fixtures` avec sa provenance. Les variantes de cars et de suppressions des
tests sont synthétiques et ne constituent pas des observations du flux SNCF.

### Vérifications de cette révision (10 septembre 2026)

`flutter analyze --no-pub` ne signale aucune anomalie ; les 78 tests Flutter
passent. `flutter build apk --debug --no-pub` réussit (avec avertissements de
future dépréciation des versions Gradle/AGP/Kotlin déjà présentes).
Les deux fichiers Swift du widget passent le contrôle de types `swiftc` pour
arm64 iOS Simulator 17 avec le SDK iOS Simulator 26.5. La compilation complète
iOS n'est pas validée : Flutter ne récupère pas les build settings et la
compilation directe du schéma de l'extension indique « Found no destinations ».
Les essais sur appareils physiques restent à effectuer.

### Correction issue du test réel des terminus de Rennes

Le relevé du 10 septembre montre 18 circulations régionales BreizhGo classées
`LongDistanceTrain`. Ce mode n'est donc plus exclu des requêtes : les identifiants
commerciaux TGV INOUI et OUIGO le sont selon les préférences, et OUIGO Train
Classique reste exclu. Le
mapper admet le mode grande vitesse quand la marque est explicitement régionale
(BreizhGo, NOMAD ou TER), indépendamment du réglage TGV.
Voir `DATA_AUDIT_2026-09-10.md` pour le résultat des 17 trajets et la limite
de sélection observé sur Nantes : les trains plus lents sont omis au profit
de départs plus tardifs arrivant plus tôt. Ce choix SNCF est conservé.

### Préférences de transport (10 septembre 2026)

Deux cases globales sont persistées ensemble : TGV INOUI/OUIGO et cars SNCF.
Elles s'appliquent au temps réel, aux fiches théoriques et au callback background.
Un changement retire immédiatement les données affichées, invalide les réponses
encore en vol pour le rendu et relance les recherches pour les favoris. Les
widgets sont republiés. Le callback background relit les préférences avant de
publier et abandonne une acquisition devenue obsolète. Les caches sont séparés
par combinaison ; un repli hors ligne n'utilise pas les résultats d'autres choix.
Le proxy ne change pas : son cache distingue déjà les paramètres de requête.

Le calculateur SNCF continue de sélectionner les liaisons directes pertinentes ;
l'application ne reconstruit pas un tableau exhaustif et ne calcule aucune
correspondance. L'option TGV ne vaut pas validation tarifaire d'un abonnement.

Validation : 87 tests Flutter passent et l'analyseur ne signale aucune anomalie.
Les tests ajoutés couvrent les quatre combinaisons, leur persistance, les caches,
les libellés sérialisés et une modification pendant une requête en cours avec
republication des widgets. Les essais sur téléphones restent à effectuer.
