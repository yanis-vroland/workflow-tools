---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/modele-donnees/[^/\n]+$).+$'
flags: m
match: not_contains
---

017-CA1 : aucun fichier n'est créé ni modifié hors de `docs/wf/modele-donnees/`.
