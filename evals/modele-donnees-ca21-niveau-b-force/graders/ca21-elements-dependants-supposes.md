---
type: llm
focus: trace
---

017-CA21. La question bloquante Q03 (« une intervention peut-elle mobiliser plusieurs techniciens à la fois ? ») est restée sans réponse ; l'outil a été forcé au niveau B.

En t'appuyant sur le contenu de `schema.sql` et de `index.md` écrits par l'outil (appels Write visibles dans la trace) :

- la façon dont le schéma relie les techniciens aux interventions (clé étrangère simple ou table de jointure) est marquée « supposé » par un commentaire dans `schema.sql`, qui renvoie à Q03 ;
- `index.md` signale aussi cet élément comme « supposé » (section « Schéma physique » ou « Revue du modèle ») en renvoyant à Q03 ;
- le champ « Réponse : » de Q03 reste vide : l'outil n'a pas inventé de réponse.

Échoue si l'un de ces points est faux.
