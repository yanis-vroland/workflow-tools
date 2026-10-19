---
type: llm
focus: trace
---

017-CA14 (niveau B). La réponse saisie à Q03 rend plusieurs à plusieurs (n-n) la relation entre technicien et intervention.

Dans le contenu de `docs/wf/modele-donnees/schema.sql` écrit par l'outil (appel Write visible dans la trace), cette relation est portée par une table de jointure qui déclare deux clés étrangères, l'une vers la table des techniciens et l'autre vers celle des interventions. À défaut, la section « Revue du modèle » de `index.md` signale explicitement cette relation n-n sans table de jointure.

Échoue si la relation n'a ni table de jointure ni signalement dans « Revue du modèle ».
