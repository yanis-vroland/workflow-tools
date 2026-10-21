---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/specs-tickets\.md$).+$'
flags: m
match: not_contains
---

006-CA1 : aucun fichier autre que `docs/wf/specs-tickets.md` n'est créé pendant l'exécution.
