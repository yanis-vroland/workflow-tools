---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA7. Repère chaque tâche `Cnn` dont l'estimation haute est au moins le double de l'estimation basse (ex. 1 et 2, 1,5 et 3, 0,5 et 2).

Pour chacune, sa colonne « Commentaire » :

- explique l'incertitude (ce qui pourrait faire monter la charge) ;
- cite l'hypothèse ou le risque qui la cause : un identifiant de question `Qnn` du cadrage, une hypothèse de la section « Hypothèses », ou un risque de la section « Risques » (renvoi explicite).

S'il n'existe aucune telle tâche, le critère est satisfait. Échoue si une de ces tâches a un commentaire vide, générique (« incertitude », « à affiner ») ou sans renvoi à une hypothèse ou un risque.
