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

Après tous les contrôles, la CI génère un bundle **non signé**, puis un artefact
`surlequai-X.Y.Z+BUILD-unsigned` téléchargeable dans GitHub Actions pendant
30 jours. Il contient le `.aab`, son SHA-256 et la version/commit/tag d'origine.
Le suffixe `-unsigned` indique qu'il ne peut pas encore être déposé sur Google Play.

## Signature exclusivement locale

Aucune clé ni aucun mot de passe Android n'est nécessaire sur GitHub. Le workflow
n'utilise ni secrets de signature ni environnement de publication. L'ancien
environnement `android-release`, s'il existe encore, est inutilisé et peut être supprimé.

La CI définit `SURLEQUAI_UNSIGNED_RELEASE=true` : Gradle ne lit alors pas
`android/key.properties` et ne configure aucune signature, même si une clé locale
est présente. Un contrôle du ZIP refuse tout bundle contenant une signature.
Sans cette variable, les compilations locales conservent leur signature habituelle
avec `android/key.properties`.

Après téléchargement et extraction de l'artefact :

1. Vérifier dans `BUILD.txt` le tag et le commit attendus.
2. Vérifier l'intégrité depuis le dossier extrait : `shasum -a 256 -c SHA256SUMS.txt`.
   Cette empreinte détecte une corruption ; elle ne prouve pas à elle seule la
   fiabilité du contenu produit par la CI. Ne signer qu'une exécution de confiance.
3. Depuis le dépôt, lancer la signature avec Java 21 (`jarsigner` dans le PATH) :

```sh
python3 scripts/sign_android_bundle.py \
  '/chemin/vers/surlequai-0.12.1+2006-unsigned.aab' \
  --keystore android/app/surlequai-release.keystore \
  --alias 'ALIAS_LOCAL'
```

Remplacer `ALIAS_LOCAL` par la valeur `keyAlias` de `android/key.properties`.
`jarsigner` demande les mots de passe directement dans le terminal : ne pas les
ajouter à la commande. La clé existante reste sur le Mac. Le script refuse un
bundle déjà signé et n'écrase pas un fichier de sortie existant.

Le résultat et sa nouvelle empreinte sont placés dans `play-release/signed/`,
répertoire ignoré par Git. Déposer ce **bundle signé** manuellement dans Google
Play Console. Le bundle téléchargé reste inchangé. Conserver la clé et ses mots
de passe dans une sauvegarde privée indépendante du dépôt.

## Protection de main

Exiger une pull request et les deux statuts `Flutter and Android` et
`Proxy and release checks`, avec branche à jour avant fusion. Aucun avis humain
supplémentaire n'est imposé au mainteneur unique. Interdire les pushes forcés et
la suppression de `main`, et appliquer ces règles aux administrateurs.

Documentation :
- https://docs.github.com/en/actions/reference/workflows-and-actions/events-that-trigger-workflows
- https://developer.android.com/studio/publish/app-signing
- https://github.com/subosito/flutter-action
