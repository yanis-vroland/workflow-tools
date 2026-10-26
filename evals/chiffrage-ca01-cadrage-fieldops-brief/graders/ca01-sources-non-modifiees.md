---
type: llm
focus: trace
---

005-CA1 (aucun autre fichier modifié). Vérifie dans la trace :

- Aucun appel d'outil (Write, Edit, NotebookEdit, ou commande Bash qui écrit, déplace, renomme, supprime ou modifie un fichier : redirection `>` ou `>>` vers un fichier, `sed -i`, `mv`, `rm`, `cp`, `touch`, `tee`…) ne vise `docs/wf/cadrage-besoin.md`, `brief-fieldops.md`, `notes-appel.md`, ni un fichier du dossier `notes/`.
- Le seul fichier écrit dans le répertoire de travail est `docs/wf/chiffrage.md`.

Échoue si l'une de ces affirmations est fausse.
