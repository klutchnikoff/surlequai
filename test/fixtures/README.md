# Réponses de référence

`bruz_rennes_20260910.json` provient de la consultation réelle du proxy de
SurLeQuai le 10 septembre 2026 à 07:42:57 Europe/Paris, avec
`data_freshness=realtime`, `max_nb_transfers=0`, entre les gares SNCF
87471037 et 87471003. Les deux premiers trajets ont été conservés ; les données
géographiques, administratives et les métadonnées sans rôle dans le traitement
ont été retirées. Les sections, horaires, modes et liens utiles sont conservés.
Les tests modifient explicitement cette base pour construire les cas limites ;
ces variantes ne sont pas des observations de suppressions ou de cars réels.

`rennes_nantes_20260910.json` contient le premier trajet de la réponse réelle
Rennes → Nantes du même jour, train 858311 (08:35 → 08:40), marqué BreizhGo
et `LongDistanceTrain`. Même réduction des métadonnées ; la liste des
perturbations est retirée pour isoler le calcul horaire et la classification.
