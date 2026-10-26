---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/chiffrage\.md$).+$'
flags: m
match: not_contains
---

005-CA18 : le livrable est mis à jour au lieu d'être dupliqué ; aucun autre fichier (copie datée, numérotée…) n'est créé.
