---
type: llm
focus: trace
---

007-CA1 (aucun autre fichier modifié, en particulier le fichier de notes). Vérifie dans la trace :

- Aucun appel d'outil (Write, Edit, NotebookEdit, ou commande Bash qui écrit, déplace, renomme, supprime ou modifie un fichier : redirection `>` ou `>>`, `sed -i`, `mv`, `rm`, `cp`, `touch`…) ne vise `notes/2026-10-07-point-hebdo.md`, ni aucun autre fichier du dossier `notes/`, ni `brief-fieldops.md`, ni `notes-appel.md`.
- Les seuls fichiers écrits sont sous `docs/wf/compte-rendu/` (la création des dossiers `docs/wf/` et `docs/wf/compte-rendu/` est permise).

Échoue si l'une de ces affirmations est fausse.
