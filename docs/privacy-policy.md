# Données et confidentialité — SurLeQuai

Mise à jour : 8 septembre 2026.

SurLeQuai est développée par Nicolas Klutchnikoff. L'application ne demande pas
de compte et ne contient pas de publicité ni d'outil de suivi publicitaire.
Cette page décrit le fonctionnement du code de cette révision ; les modifications
du proxy prennent effet lors de son déploiement.

## Sur votre appareil

Les favoris, préférences et horaires en cache sont conservés localement. Une clé
SNCF personnelle, si vous en fournissez une, est conservée par
`flutter_secure_storage`. Les widgets accèdent aux données locales partagées par
l'application. Sur Android, leur actualisation peut déclencher des requêtes réseau
en arrière-plan selon le même mode de connexion que l'application.

Vider le cache efface les horaires enregistrés, mais conserve les favoris,
préférences et la clé personnelle. Les favoris peuvent être supprimés dans
l'application et la clé personnelle dans les paramètres avancés.

## Consultations réseau

Pour obtenir les horaires ou rechercher une gare, l'application transmet les
identifiants ou termes recherchés, les dates et les paramètres de consultation.

En mode proxy, ces requêtes passent par Cloudflare puis SNCF. Cloudflare reçoit
l'adresse IP du téléphone. Le code du proxy construit les en-têtes amont sans
transmettre les cookies ni les en-têtes d'adresse IP du téléphone à SNCF. Il ne
journalise pas les requêtes et ne stocke pas les trajets dans KV. Il utilise un
identifiant pseudonyme renouvelé chaque heure pour limiter les abus, ainsi qu'un
compteur global approximatif. Les traitements d'infrastructure propres aux
fournisseurs ne sont pas contrôlés par le code de l'application.

En mode clé personnelle (BYOK), l'application contacte SNCF directement : SNCF
reçoit alors la connexion et l'adresse IP du téléphone.

Le [document de transparence du proxy](../cloudflare-worker/TRANSPARENCY.md)
détaille ce périmètre. Les favoris sont conservés localement, mais les gares et
horaires demandés doivent donc être transmis pour obtenir des résultats.

## Code et contact

Le [code source](https://github.com/klutchnikoff/surlequai) permet d'examiner les
appels réseau et le stockage. Contact : nicolas.klutchnikoff@gmail.com ou
[les tickets du dépôt](https://github.com/klutchnikoff/surlequai/issues).
