---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/specs-tickets\.md$).+$'
flags: m
match: not_contains
---

006-CA16 : la relance met à jour `docs/wf/specs-tickets.md` au lieu de créer un autre fichier (aucun livrable dupliqué à côté).
