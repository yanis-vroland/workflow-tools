---
type: llm
focus: trace
---

017-CA31. En t'appuyant sur le contenu de `docs/wf/modele-donnees/index.md` et de `migration.sql` écrits par l'outil (appels Write visibles dans la trace), et sur les recherches faites dans le code (Grep, Read) :

- pour chaque table existante que la migration modifie (colonne ajoutée, modifiée, renommée ou supprimée), « Évolution » liste les fichiers du code qui utilisent cette table ou cette colonne, chacun avec son chemin relatif (ex. `src/api/routes/interventions.ts`) et l'élément utilisé (table, colonne, requête) ;
- les chemins cités existent dans le projet (ils apparaissent dans les résultats de Glob, Grep ou Read de la trace) ;
- une migration qui ne fait qu'ajouter une table nouvelle peut indiquer qu'aucun fichier existant ne l'utilise encore.

Échoue si une table modifiée n'a pas sa liste de fichiers, si un fichier cité n'existe pas, ou si un fichier n'a pas son élément utilisé.
