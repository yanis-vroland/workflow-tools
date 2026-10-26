---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/chiffrage\.md$).+$'
flags: m
match: not_contains
---

005-CA1 : aucun fichier autre que `docs/wf/chiffrage.md` n'est créé pendant l'exécution.
