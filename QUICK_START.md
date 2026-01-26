# 🚀 Démarrage rapide - SurLeQuai avec API Navitia

**3 minutes pour avoir l'app avec données réelles !**

---

## 📋 Ce dont vous avez besoin

- ✅ Votre clé API Navitia (que vous avez déjà)
- ✅ Flutter installé
- ✅ Un émulateur ou téléphone

---

## ⚡ 3 étapes rapides

### 1️⃣ Créer le fichier `.env`

```bash
cd /Users/nicolas/Documents/git/surlequai
touch .env
```

### 2️⃣ Coller votre clé API

Ouvrez `.env` et ajoutez :

```env
NAVITIA_API_KEY=VOTRE_CLE_API_ICI
NAVITIA_API_BASE_URL=https://api.sncf.com/v1
```

**Remplacez `VOTRE_CLE_API_ICI` par votre vraie clé !**

### 3️⃣ Lancer l'app

```bash
flutter run
```

---

## ✅ Vérifier que ça marche

Au démarrage, vous devriez voir dans les logs :

```
[Main] Fichier .env chargé avec succès
```

Ensuite, dans l'app :
- Ouvrez le drawer (☰)
- Le trajet "Rennes ⟷ Nantes" est déjà configuré
- Vous voyez les **vrais horaires temps réel** 🎉

---

## 🐛 Problèmes ?

### "Fichier .env non trouvé"
→ Le fichier `.env` doit être à la racine du projet (même niveau que `pubspec.yaml`)

### "Clé API invalide" (401)
→ Vérifiez que votre clé est correcte sur https://www.navitia.io/

### L'app affiche toujours des mocks
→ Faites `flutter clean && flutter run`

---

## 📚 Documentation complète

Pour plus de détails, consultez :
- `README_API_SETUP.md` - Guide complet
- `INTEGRATION_API_COMPLETE.md` - Documentation technique

---

**Bonne route sur les rails ! 🚂**
