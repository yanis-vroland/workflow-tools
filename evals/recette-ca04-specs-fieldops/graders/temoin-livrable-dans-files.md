---
type: regex
target: files
pattern: '^docs/wf/recette\.md$'
flags: m
match: contains
---

Témoin des correcteurs `target: files` : la liste des fichiers de la session
contient bien le livrable. Sans lui, une liste vide ferait passer
`ca01-aucun-autre-fichier-cree` sans rien vérifier.
