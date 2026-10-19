---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA16. `index.md` liste chaque fichier non Markdown du dossier `docs/wf/modele-donnees/` avec son rôle : au moins `schema.sql` (création complète, première migration), `donnees-test.sql` (données de test fictives) et `requetes.sql` (requêtes de vérification). Le fichier `migration.sql`, présent dans le dossier mais sans objet au niveau B, est lui aussi mentionné (voir CA37).

Échoue si l'un de ces fichiers n'est pas listé, ou si un fichier listé n'a pas de rôle.
