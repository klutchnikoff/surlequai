# Documentation Assets

Assets pour la **documentation** (GitHub, site web) - **NON EMBARQUÉS dans l'app**.

## Structure

```
docs/assets/
├── logo.png              ← Logo SurLeQuai pour README.md
└── screenshots/          ← Captures d'écran de l'app
    ├── 1-home.png        ← Écran d'accueil (vide)
    ├── 2-add-trip.png    ← Ajout d'un trajet
    ├── 3-trip-list.png   ← Liste des trajets
    └── 4-widget.png      ← Widget sur écran d'accueil
```

## Usage

Ces fichiers sont référencés dans :
- `README.md` (racine du projet)
- GitHub Pages (docs/)
- Documentation technique

## Recommandations

- **Format** : PNG avec transparence
- **Taille screenshots** : ~400-800px de largeur (optimisé pour GitHub)
- **Taille logo** : 512x512px recommandé
- **Compression** : Utiliser TinyPNG ou ImageOptim pour réduire la taille

---

**Voir aussi :**
- `assets/` - Assets embarqués dans l'app
- `store-assets/` - Assets pour app stores
