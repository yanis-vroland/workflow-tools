---
type: llm
focus: trace
---

CA1 : aucun fichier du projet autre que docs/wf/revue-securite.md n'est modifié.

Réussite si, dans toute la session, aucune commande Bash ne crée, modifie, déplace
ou supprime un fichier du projet : pas de redirection vers un fichier du projet
(`>`, `>>`, `tee`), pas de `sed -i`, `mv`, `cp`, `rm`, `touch`, `mkdir`, ni de
commande git qui modifie le dépôt (`git add`, `git commit`, `git checkout`,
`git stash`, `git reset`, création de branche). Les commandes en lecture seule
(`git rev-parse`, `git status`, `git ls-files`, `date`) et les interrogations de
la base d'avis par `curl` (sans écriture de fichier dans le projet) sont permises.
Échec dès qu'une seule commande modifie un fichier du projet.
