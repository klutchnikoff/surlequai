# Configuration de l'API Navitia

Ce guide vous explique comment configurer votre clé API SNCF/Navitia pour que l'application **SurLeQuai** fonctionne avec des données réelles.

---

## 📋 Prérequis

Vous devez avoir obtenu une **clé API Navitia** depuis le portail SNCF Open Data.

Si ce n'est pas encore fait : https://www.navitia.io/

---

## ⚙️ Configuration en 3 étapes

### 1. Créer le fichier `.env`

À la racine du projet (au même niveau que `pubspec.yaml`), créez un fichier nommé **`.env`** :

```bash
touch .env
```

### 2. Ajouter votre clé API

Ouvrez le fichier `.env` et collez-y votre clé API :

```env
NAVITIA_API_KEY=votre_cle_api_ici
NAVITIA_API_BASE_URL=https://api.sncf.com/v1
```

**Exemple** :
```env
NAVITIA_API_KEY=a1b2c3d4-e5f6-7890-abcd-ef1234567890
NAVITIA_API_BASE_URL=https://api.sncf.com/v1
```

**Note** : Si votre clé vient de navitia.io (et non api.sncf.com), utilisez `https://api.navitia.io/v1` à la place.

### 3. Installer les dépendances

Exécutez la commande suivante pour installer les nouvelles dépendances :

```bash
flutter pub get
```

---

## 🚀 Lancer l'application

Une fois configuré, lancez l'application normalement :

```bash
flutter run
```

L'application va maintenant :
- ✅ Charger la clé API depuis `.env`
- ✅ Appeler l'API Navitia pour récupérer les horaires temps réel
- ✅ Afficher les vrais horaires de trains avec retards et suppressions

---

## 🐛 Dépannage

### Problème : "Clé API non configurée"

**Cause** : Le fichier `.env` n'existe pas ou est mal formaté.

**Solution** :
1. Vérifiez que le fichier `.env` est bien à la racine du projet
2. Vérifiez qu'il contient bien `NAVITIA_API_KEY=...`
3. Relancez l'application

### Problème : "Clé API invalide ou expirée" (401)

**Cause** : La clé API n'est pas valide ou a expiré.

**Solution** :
1. Reconnectez-vous sur https://www.navitia.io/
2. Vérifiez que votre clé est toujours active
3. Générez une nouvelle clé si nécessaire
4. Mettez à jour le fichier `.env`

### Problème : "Gare non trouvée" (404)

**Cause** : L'ID de la gare n'existe pas dans l'API Navitia.

**Solution** :
1. Utilisez la recherche de gares dans l'application
2. Les IDs Navitia ont le format : `stop_area:SNCF:87XXXXXX`
3. Exemple : Rennes = `stop_area:SNCF:87471003`

### Problème : L'app affiche toujours des données mock

**Cause** : Le fichier `.env` n'est pas chargé correctement.

**Solution** :
1. Vérifiez les logs au démarrage : `[Main] Fichier .env chargé avec succès`
2. Si vous voyez `[Main] Fichier .env non trouvé`, recréez le fichier `.env`
3. Faites un `flutter clean` puis `flutter run`

---

## 🔒 Sécurité

### ⚠️ IMPORTANT

Le fichier `.env` contient votre clé API privée. **NE LE COMMITTEZ JAMAIS !**

Le fichier `.env` est déjà dans `.gitignore` pour éviter cela.

### Vérifier avant un commit

Avant de commit, vérifiez que `.env` n'apparaît pas :

```bash
git status
```

Vous devriez voir :
- ✅ `.env.example` (template sans vraie clé)
- ❌ `.env` (ne doit PAS apparaître)

---

## 📚 Codes de gares Navitia

Quelques exemples de codes de gares pour tester :

| Gare | Code Navitia |
|------|--------------|
| Rennes | `stop_area:SNCF:87471003` |
| Nantes | `stop_area:SNCF:87481002` |
| Paris Montparnasse | `stop_area:SNCF:87391003` |
| Lyon Part-Dieu | `stop_area:SNCF:87723197` |
| Bordeaux St-Jean | `stop_area:SNCF:87581009` |

**Note** : Vous n'avez pas besoin de connaître les codes manuellement. Utilisez la recherche de gares intégrée à l'application !

---

## 🧪 Mode développement (sans clé API)

Si vous voulez développer sans clé API, l'application fonctionne en **mode mock** avec des horaires fictifs.

Avantages :
- ✅ Pas besoin de clé API
- ✅ Données de test cohérentes
- ✅ Fonctionne hors-ligne

Inconvénients :
- ❌ Horaires fictifs (trains toutes les 20 min)
- ❌ Pas de données temps réel
- ❌ Gares limitées (Rennes, Nantes, Paris, Lyon, Bordeaux, Toulouse)

---

## 📞 Besoin d'aide ?

- **Issues GitHub** : https://github.com/votre-repo/surlequai/issues
- **Documentation Navitia** : https://doc.navitia.io/
- **API SNCF** : https://api.sncf.com/

---

**Version** : 1.0
**Dernière mise à jour** : 26 janvier 2026
