# Données traitées par le proxy SurLeQuai

Mise à jour : 8 septembre 2026. Ce document décrit le code de cette révision ;
le service publié peut utiliser une autre révision tant qu'elle n'est pas déployée.

Le téléphone transmet au proxy les gares, dates et paramètres nécessaires pour
consulter les horaires. Cloudflare reçoit la connexion du téléphone, y compris
son adresse IP. Le Worker transmet les paramètres de consultation à l'API SNCF
avec la clé du service, mais ne transmet pas les en-têtes IP ou cookies du client.

Le code applicatif du Worker :

- ne journalise pas les requêtes et ne crée pas de cookies ;
- ne stocke pas les gares, trajets ou IP en clair dans KV ;
- utilise un identifiant pseudonyme HMAC pour la protection contre les abus,
  calculé avec un secret et renouvelé chaque heure ;
- transmet cet identifiant au limiteur natif Cloudflare, configuré sur 60 secondes ;
- conserve dans `STATS_KV` un compteur global approximatif des réponses amont.

La période de limitation n'est pas une garantie de suppression des données
techniques de l'hébergeur après 60 secondes. L'identifiant HMAC reste stable au
cours d'une heure : il est pseudonyme, pas une garantie d'anonymat absolu.
L'observabilité Workers est désactivée dans le fichier de configuration du dépôt.
Les journaux d'infrastructure, outils de diagnostic activés par un administrateur
et traitements propres à Cloudflare ou SNCF ne sont pas contrôlés par ce code.

Le mode clé personnelle (BYOK) permet à l'application d'interroger directement
SNCF. SNCF reçoit alors directement la connexion du téléphone. La clé est
conservée par `flutter_secure_storage` sur l'appareil.

Le comportement peut être examiné dans [worker.js](worker.js) et ses tests.
Aucun audit juridique ni certification de conformité n'est revendiqué ici.
