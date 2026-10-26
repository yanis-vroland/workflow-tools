---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA16. La section « Dette et risques » de `docs/wf/analyse-projet.md` contient deux risques de niveau élevé :

1. une requête SQL construite par concaténation dans la route de détail des interventions, fichier le plus modifié et non testé (`src/api/routes/interventions.ts`) ;
2. le build `release` de l'application mobile signé avec la configuration `debug` (`mobile/android/app/build.gradle`).

Vérifie dans le livrable :

- les deux risques élevés figurent dans « Risques », chacun en citant `analyse-projet.md` comme source ;
- le risque SQL cite au moins une tâche `Cnn`, et au moins une des tâches qu'il cite est une tâche des tableaux dont la colonne « Commentaire » nomme le fichier `src/api/routes/interventions.ts` (les évolutions demandées touchent la liste des interventions, servie par ce fichier) ;
- le risque de signature mobile porte « aucune tâche affectée » (aucune évolution ne touche `mobile/`), sauf si une tâche du livrable porte réellement sur `mobile/`.

Échoue si l'un de ces points est faux, en particulier si le risque SQL porte « aucune tâche affectée » ou ne cite que des tâches sans rapport avec `src/api/routes/interventions.ts`.
