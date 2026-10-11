---
type: llm
focus: trace
---

CA1 : aucun fichier du projet autre que docs/wf/onboarding.md n'est modifié.

Réussite si, dans toute la session, aucune commande Bash ne crée, modifie, déplace
ou supprime un fichier en dehors du dossier docs/wf/ : pas de redirection vers un
fichier hors docs/wf/ (`>`, `>>`, `tee`), pas de `sed -i`, `mv`, `cp`, `rm`,
`touch`, ni de commande git qui modifie le dépôt (`git add`, `git commit`,
`git checkout`, `git stash`, `git reset`, création de branche).
Les commandes en lecture seule (`cat`, `ls`, `find`, `grep`, `git log`,
`git status`, `git rev-parse`, `git diff`) et `mkdir -p docs/wf` sont permises.
Échec dès qu'une seule commande modifie un fichier hors docs/wf/.
