---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA13. Dans le cadrage :

- Q01 (volume d'interventions par mois, concerne B01 et B05) et Q03 (reprise de l'historique du tableur, concerne B04) ont un champ « Réponse : » vide et influent sur l'estimation ;
- Q02 (plateforme : application mobile Android et iOS hors connexion, back-office web) a une réponse remplie.

Vérifie :

1. la section « Hypothèses » contient une hypothèse qui cite Q01 et indique au moins une tâche `Cnn` concernée, et une hypothèse qui cite Q03 et indique au moins une tâche `Cnn` concernée ; les tâches citées existent dans les tableaux ;
2. la réponse à Q02 est prise en compte comme un fait (des tâches portent sur l'application mobile et le hors connexion) et le livrable cite Q02 à cet endroit (commentaire d'une tâche, « Périmètre chiffré » ou « Hypothèses ») ; elle n'est pas présentée comme une hypothèse à valider.

Échoue si l'un de ces points est faux.
