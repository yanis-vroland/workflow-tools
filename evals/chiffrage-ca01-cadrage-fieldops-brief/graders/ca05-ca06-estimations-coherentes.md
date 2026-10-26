---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA5 et CA6. Pour CHAQUE ligne de tâche `Cnn` des tableaux de « Détail par lot » et de « Activités transverses », lis l'estimation basse et l'estimation haute :

- les deux sont exprimées en jours (en-tête de colonne ou unité « j » / « jours »), jamais en heures, semaines ou points ;
- chacune est un multiple de 0,5 (0,5 ; 1 ; 1,5 ; 2…) ;
- l'estimation haute est supérieure ou égale à l'estimation basse ;
- l'estimation haute ne dépasse pas 5 jours.

Vérifie chaque ligne une à une. Échoue si une seule ligne viole une de ces règles.
