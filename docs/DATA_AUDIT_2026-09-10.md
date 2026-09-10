# Test réel des terminus TER de Rennes — 10 septembre 2026

Le tableau de Rennes a été interrogé pour la période 08:18–24:00 (heure de Paris). La réponse initiale est horodatée 08:22:44 : 201 départs, pagination complète, dont 115 circulations ferroviaires régionales BreizhGo/NOMAD vers 17 terminus. Parmi ces 115, 18 sont paradoxalement classées `LongDistanceTrain`. Les cars et TGV ont été exclus de la découverte des terminus.

Pour chaque terminus, consultation de `/journeys` avec les paramètres de l’application (six résultats demandés, sans correspondance), avant puis après correction. Les réponses capturées ont été rejouées dans le véritable `ApiService`, puis dans `DirectionCardViewModel`. Les résultats de chaque trajet peuvent aussi inclure des trains allant au-delà de la gare sélectionnée et des départs du lendemain.

## Résultats après correction

Les 17 tests passent : aucune réponse ne provoque une erreur de traitement, aucun trajet retourné par ces réponses ne disparaît au mapping, les cars sont distingués des trains. 94 propositions sont traitées (avec recoupements entre destinations), dont trois occurrences de cars sur Rennes → Caen. Cela ne signifie pas que les 115 départs de la journée ont tous été restitués par `/journeys`.

| Destination sélectionnée | Propositions traitées | Premier affichage, référence 08:18 |
|---|---:|---|
| Nantes | 6 | 08:35 +5 min |
| Saint-Malo | 6 | 08:35 À l'heure |
| Saint-Brieuc | 6 | 08:37 À l'heure |
| Vannes | 6 | 08:39 À l'heure |
| Montreuil-sur-Ille | 6 | 08:35 À l'heure |
| Vitré | 6 | 08:45 À l'heure |
| Messac - Guipry | 6 | 08:39 À l'heure |
| Quimper | 6 | 09:29 À l'heure |
| Caen | 6 | 11:26 À l'heure |
| Laval | 6 | 09:05 À l'heure |
| La Brohinière | 6 | 12:05 À l'heure |
| Châteaubriant | 6 | 12:56 À l'heure |
| Retiers | 6 | 12:56 À l'heure |
| Brest | 6 | 16:59 À l'heure |
| Dinan | 1 | 17:25 À l'heure |
| Le Mans | 3 | 17:42 À l'heure |
| Redon | 6 | 08:39 À l'heure |

## Défaut corrigé

Avant correction, Nantes, Laval et Le Mans donnaient une réponse `no_solution` avec le filtre `forbidden_uris[]=physical_mode:LongDistanceTrain`. Cette exclusion ajoutée dans la branche éliminait de vrais TER. Les marques commerciales TGV/OUIGO sont désormais exclues à la place. Le mapper reconnaît les trains de marque régionale malgré ce mode physique incohérent. Une fixture réelle du 858311 vers Nantes protège la correction.

## Retard et cars réellement observés

Le 858311 Rennes → Nantes est annoncé à 08:40 pour un départ théorique à 08:35 : le modèle produit +5 min, une seule fois. Le retard est apparu entre les relevés ; les réponses ne constituent donc pas un instantané atomique du réseau.

Rennes → Caen inclut notamment le car 48033 du 10 septembre à 16:15, indiqué `Autocar`, transporteur `SNCF Voyageurs`. Il est conservé avec `isCoach=true`. La réponse contient aussi deux occurrences de cars du lendemain. Aucune preuve de substitution n’est fournie : le libellé reste « Car ».

## Limite persistante : exhaustivité de Nantes

Le tableau des départs annonce les 857763 à 10:56 et 857765 à 12:56 vers Nantes. La réponse `/journeys` les omet tout en renvoyant des trains plus tardifs (jusqu’à 14:56 dans les six résultats). Ils ne sont donc pas perdus par le mapper : ils manquent dans la réponse amont. Ajouter `is_journey_schedules=true` a été testé et ne les rétablit pas.

Une sélection par le calculateur, notamment selon les heures d’arrivée, est une explication plausible ; ce test ne prouve pas le détail de l’algorithme du service SNCF déployé. L’API `/journeys` reste un calculateur d’itinéraires, pas une garantie de liste exhaustive des départs. Une autre stratégie d’acquisition serait nécessaire pour garantir tous les trains.

## Portée

Test d’intégration aux données réelles via capture/rejeu, pas un essai de l’interface sur téléphone ni une comparaison aux circulations physiques. La découverte porte sur les terminus des TER restants ce jour-là, pas toutes les destinations possibles du calendrier annuel. Aucun cas de suppression TER n’a été rencontré dans cet échantillon.

Les réponses brutes et le script de rejeu sont conservés localement dans `/tmp/surlequai-live-20260910/` (fichiers temporaires). La fixture de régression est conservée dans le dépôt.

Documentation du paramètre de comparaison : [Navitia](https://doc.navitia.io/) (`is_journey_schedules`).
