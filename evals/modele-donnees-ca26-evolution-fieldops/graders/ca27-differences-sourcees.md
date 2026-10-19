---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA27. Les notes d'appel demandent notamment que les techniciens prennent des photos de l'installation avant et après intervention, et saisissent leurs comptes rendus sur une application mobile utilisable hors connexion. Le schéma existant (`src/db/schema.sql`) n'a aucune table ni colonne pour des photos.

La section « Évolution » liste les différences entre le schéma existant et le modèle demandé :

- chaque différence est qualifiée (table ou colonne ajoutée, modifiée, renommée ou supprimée) et nomme la table et, s'il y a lieu, la colonne ;
- chaque différence a une source : phrase citée des notes d'appel (avec `notes-appel.md` et le titre de section), réponse ou décision saisie, ou la marque « supposé » ;
- les photos avant et après intervention y figurent (nouvelle table ou nouvelles colonnes) ;
- aucune différence ne contredit le schéma existant (par exemple, ne prétend pas ajouter une table ou une colonne qui existe déjà).

Échoue si une différence n'a pas de source ou de qualification, si les photos manquent, ou si une différence porte sur un élément déjà présent tel quel.
