---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/cadrage-besoin\.md$).+$'
flags: m
match: not_contains
---

004-CA1 : aucun fichier autre que `docs/wf/cadrage-besoin.md` n'est créé pendant l'exécution.
