# Intégration continue et publications Android

## Contrôles

Le workflow `CI` s'exécute sur les pull requests vers `main` et les pushes sur
`main`. Il est également réutilisé par le workflow de publication.

- `Flutter and Android` : Flutter 3.47.2 (fichier `.flutter-version`), dépendances
  de `pubspec.lock` imposées, formatage Dart, analyse statique (infos bloquantes),
  tests Flutter et compilation d'un APK debug sans clé de publication.
- `Proxy and release checks` : tests Node du proxy (réseau simulé) et tests des
  règles de version. Ce contrôle peu coûteux tourne à chaque fois, même sans
  modification du proxy, pour conserver un statut requis toujours disponible.

Aucun test n'appelle réellement SNCF. Les runners sont Ubuntu 24.04, avec Java
21 et Node 22. Les actions tierces sont fixées à des empreintes de commit ; leur
mise à jour doit être revue. Les contrôles n'ont besoin d'aucun secret.

Avant une PR, exécuter :

```sh
dart format lib test
flutter pub get --enforce-lockfile
flutter analyze --no-pub --fatal-infos
flutter test --no-pub
npm --prefix cloudflare-worker test
python3 -m unittest discover -s scripts/ci -p 'test_*.py'
flutter build apk --debug --no-pub
```

La compilation iOS sur macOS reste une étape ultérieure, après résolution de la
configuration Xcode. Cette CI ne prétend donc pas valider les binaires iOS.

## Publication : uniquement lors d'un tag

`Android release` est déclenché par un **push de tag `v*`**, jamais par un push
ordinaire, une PR ou un lancement manuel. Aucun dépôt automatique dans Google
Play, aucune release GitHub automatique et aucun déploiement Cloudflare.

Le tag doit être exactement `v` suivi de la version de `pubspec.yaml`, build
compris : par exemple `v0.12.1+2006` pour `version: 0.12.1+2006`.

1. Modifier `pubspec.yaml`, avec un numéro de build inédit et croissant.
2. Faire valider et fusionner la PR dans `main`.
3. Mettre à jour le checkout local de `main`.
4. Créer puis pousser le tag correspondant :

```sh
git tag -a 'v0.12.1+2006' -m 'SurLeQuai 0.12.1 (2006)'
git push origin 'v0.12.1+2006'
```

Les valeurs ci-dessus sont un exemple : ne pas taguer sans mettre à jour la
version. Le build 2005 a déjà été déposé manuellement dans Play Console.

Le workflow vérifie la correspondance du tag, l'appartenance du commit à
l'historique de `main`, et la progression du build par rapport aux autres tags
au format `vX.Y.Z+BUILD`. **Il ne consulte pas Google Play** : les versions
précédemment déposées à la main doivent également être prises en compte. Ne pas
supprimer/déplacer les tags de publication ; ne pas réutiliser un numéro déjà
importé dans Play Console.

Après tous les contrôles, la CI génère un bundle signé, puis un artefact
`surlequai-X.Y.Z+BUILD` téléchargeable dans l'exécution GitHub Actions pendant
30 jours. Il contient le `.aab`, son SHA-256 et la version/commit/tag d'origine.
Conserver localement le bundle destiné à publication avant expiration.

## Signature

L'environnement GitHub `android-release` est réservé aux tags `v*`. Il doit contenir :

- `ANDROID_KEYSTORE_BASE64` : contenu de la clé d'importation existante, encodé en base64 ;
- `ANDROID_KEYSTORE_PASSWORD` : mot de passe du keystore ;
- `ANDROID_KEY_ALIAS` : alias de la clé ;
- `ANDROID_KEY_PASSWORD` : mot de passe de la clé.

Les secrets ne sont pas configurés automatiquement : les renseigner dans
Settings → Environments → android-release → Environment secrets du dépôt.
Le workflow échoue explicitement si un secret manque.

Base64 n'est pas un chiffrement : la protection repose sur les secrets GitHub.
La clé est décodée uniquement dans le répertoire temporaire du runner du job de
signature (permissions 0600), puis supprimée même en cas d'échec. Elle n'entre
ni dans les artefacts ni dans le cache Flutter. Aucun secret n'est transmis au
workflow réutilisable des contrôles ni aux tests de PR.

Gradle utilise ces variables uniquement quand `ANDROID_KEYSTORE_PATH` existe ;
les compilations locales continuent d'utiliser `android/key.properties`.

## Protection de main

Exiger une pull request et les deux statuts `Flutter and Android` et
`Proxy and release checks`, avec branche à jour avant fusion. Aucun avis humain
supplémentaire n'est imposé au mainteneur unique. Interdire les pushes forcés et
la suppression de `main`, et appliquer ces règles aux administrateurs.

Documentation :
- https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows
- https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets
- https://github.com/subosito/flutter-action
