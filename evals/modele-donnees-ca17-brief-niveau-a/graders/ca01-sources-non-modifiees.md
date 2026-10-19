---
type: llm
focus: trace
---

017-CA1 (aucun fichier hors du livrable créé ni modifié, y compris les sources). Vérifie dans la trace :

- Aucun appel d'outil (Write, Edit, NotebookEdit, ou commande Bash qui écrit, déplace, renomme, supprime ou modifie un fichier : redirection `>` ou `>>`, `sed -i`, `mv`, `rm`, `cp`, `touch`, `tee`…) ne vise `brief-fieldops.md`, `notes-appel.md`, ni un fichier du dossier `notes/`.
- Le seul fichier écrit est `docs/wf/modele-donnees/index.md` (la création des dossiers `docs/wf/modele-donnees/` est permise). Aucun fichier temporaire n'est écrit, ni dans le projet ni ailleurs.

Échoue si l'une de ces affirmations est fausse.
