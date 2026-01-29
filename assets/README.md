# Assets - Application

Assets **EMBARQUÉS** dans l'application Flutter (APK/IPA).

## Structure

```
assets/
├── images/
│   └── app-icon.png       ← Icône affichée dans l'écran "À propos"
└── icon/                  ← Fichiers générés par flutter_launcher_icons
    ├── icon-android.png   ← (Généré automatiquement)
    ├── icon-ios.png       ← (Généré automatiquement)
    ├── icon-splash.png    ← Splash screen
    └── transparent.png    ← (Usage à vérifier)
```

## Assets Déclarés (pubspec.yaml)

Seuls les fichiers listés dans `pubspec.yaml` sont embarqués :
```yaml
assets:
  - assets/images/app-icon.png
```

## Note

Les fichiers dans `icon/` sont générés par le package `flutter_launcher_icons`.
Ne les modifiez pas manuellement - utilisez la configuration dans `pubspec.yaml`.

---

**Voir aussi :**
- `docs/assets/` - Assets de documentation (README, screenshots GitHub)
- `store-assets/` - Assets pour app stores (non embarqués)
