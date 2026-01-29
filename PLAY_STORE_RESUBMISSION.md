# Resoumission Google Play Store - v0.11.0

## Résumé du Problème
**Rejet** : Violation de la politique "Misleading Claims"
**Raison** : Manque de lien vers source officielle + pas de disclaimer sur affiliation gouvernementale

## Corrections Apportées

### 1. ✅ Description Play Store Mise à Jour
- **Fichier** : `play_store_description_fr.txt`
- **Ajouts** :
  - ⚠️ Disclaimer en tête : "APPLICATION NON OFFICIELLE"
  - 🔗 Lien source officielle : https://www.sncf.com/fr/groupe/open-data
  - 🔗 Lien portail national : https://transport.data.gouv.fr
  - 📝 Mention claire : "Cette application n'est pas un service officiel de la SNCF"

### 2. ✅ Disclaimer dans l'Application
- **Fichier** : `lib/screens/about_screen.dart`
- **Nouvelle section** : "⚠️ Application non officielle"
- **Contenu** :
  - Affirmation claire de non-affiliation SNCF/gouvernement
  - Explication : projet indépendant utilisant données publiques
  - Redirection vers services officiels SNCF pour informations garanties
  - Liens cliquables vers sources officielles

### 3. ✅ Version Bumped
- **Ancienne** : 0.10.0+2
- **Nouvelle** : 0.11.0+3
- **Justification** : Changements architecturaux majeurs depuis 0.10.0 (Freezed, RadioGroup, etc.)

## Actions à Réaliser dans Google Play Console

### Étape 1 : Mettre à Jour la Description
1. Aller dans **Store presence** > **Main store listing**
2. Langue : **Français (France)**
3. Copier-coller le contenu de `play_store_description_fr.txt` dans **Full description**
4. **Sauvegarder** (ne pas publier tout de suite)

### Étape 2 : Upload Nouvelle Version
1. Créer un nouveau **Release** (Internal testing)
2. Upload du fichier : `build/app/outputs/bundle/release/app-release.aab`
3. Version : **0.11.0 (3)**
4. Release notes :
   ```
   v0.11.0 - Conformité Google Play

   - Ajout de disclaimers clairs sur la non-affiliation SNCF
   - Ajout de liens vers les sources officielles des données
   - Amélioration de l'écran "À propos"
   - Corrections UI (boutons radio en vertical)
   - Migration APIs dépréciées (Flutter 3.32+)
   ```

### Étape 3 : Répondre au Rejet
Dans l'email de rejet, cliquer sur **"Submit appeal"** ou **"Resubmit"** et écrire :

```
Bonjour,

Nous avons pris en compte vos remarques concernant la politique Misleading Claims.

Modifications apportées dans la version 0.11.0 :

1. Description mise à jour avec :
   - Disclaimer explicite en tête : "APPLICATION NON OFFICIELLE - Cette application n'est pas affiliée à la SNCF ni à aucune entité gouvernementale"
   - Liens vers les sources officielles des données :
     * https://www.sncf.com/fr/groupe/open-data
     * https://transport.data.gouv.fr
   - Mention claire que l'app n'est pas un service officiel SNCF

2. Dans l'application elle-même (écran "À propos") :
   - Nouvelle section "⚠️ Application non officielle"
   - Explication détaillée de la nature indépendante du projet
   - Liens cliquables vers les portails officiels
   - Redirection vers les services officiels SNCF pour informations garanties

L'application respecte désormais pleinement la politique Misleading Claims en clarifiant sa non-affiliation gouvernementale et en citant ses sources officielles.

Cordialement,
Nicolas Klutchnikoff
```

## Build Commands

```bash
# 1. Nettoyer le build précédent
flutter clean

# 2. Récupérer les dépendances
flutter pub get

# 3. Build Android App Bundle (pour Play Store)
flutter build appbundle --release

# 4. Vérifier le fichier généré
ls -lh build/app/outputs/bundle/release/app-release.aab

# 5. (Optionnel) Build APK pour test local
flutter build apk --release
```

## Checklist Finale

- [ ] Description Play Store mise à jour avec disclaimers
- [ ] Liens vers sources officielles ajoutés
- [ ] Écran "À propos" mis à jour dans l'app
- [ ] Version bumped à 0.11.0+3
- [ ] App Bundle généré (`.aab`)
- [ ] Test de l'app en mode release
- [ ] Vérification que les liens s'ouvrent correctement
- [ ] Upload dans Play Console
- [ ] Réponse au rejet soumise

## Liens Utiles

- Google Play Console : https://play.google.com/console
- Politique Misleading Claims : https://support.google.com/googleplay/android-developer/answer/9888379
- SNCF Open Data : https://www.sncf.com/fr/groupe/open-data
- Transport Data Gouv : https://transport.data.gouv.fr

---
**Date** : 2026-01-29
**Version** : 0.11.0+3
**Auteur** : Nicolas Klutchnikoff
