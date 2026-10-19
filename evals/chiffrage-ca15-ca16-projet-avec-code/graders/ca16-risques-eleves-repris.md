---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA16. La section « Dette et risques » de `docs/wf/analyse-projet.md` contient deux risques de niveau élevé :

1. une requête SQL construite par concaténation dans la route de détail des interventions, fichier le plus modifié et non testé (`src/api/routes/interventions.ts`) ;
2. le build `release` de l'application mobile signé avec la configuration `debug` (`mobile/android/app/build.gradle`).

Dans la section « Risques » du livrable :

- chacun des deux risques élevés est repris ;
- chacun cite le livrable d'analyse (`analyse-projet.md`) comme source ;
- chacun indique les tâches `Cnn` qu'il affecte (des tâches qui existent dans les tableaux) ou « aucune tâche affectée » ;
- le risque de signature mobile n'affecte aucune des évolutions (toutes sur le back-office web) : il porte la mention « aucune tâche affectée », sauf si une tâche du livrable porte réellement sur `mobile/`.

Échoue si l'un de ces points est faux.
