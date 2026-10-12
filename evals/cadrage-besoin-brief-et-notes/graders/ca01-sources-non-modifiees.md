---
type: llm
focus: trace
---

004-CA1 (aucun autre fichier modifié, y compris le brief). Vérifie dans la trace :

- Aucun appel d'outil (Write, Edit, NotebookEdit, ou commande Bash qui écrit, déplace, renomme, supprime ou modifie un fichier : redirection `>` ou `>>`, `sed -i`, `mv`, `rm`, `cp` vers un fichier existant, `touch`…) ne vise `brief-fieldops.md`, `notes-appel.md`, ni un fichier du dossier `notes/`.
- Le seul fichier écrit dans le répertoire de travail est `docs/wf/cadrage-besoin.md` (la création du dossier `docs/wf/` est permise).

Échoue si l'une de ces affirmations est fausse.
