---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:\n\|\s*(REC-\d{3})\s*\|[\s\S]*\n\|\s*\1\s*\|)|2026-09-15'
match: not_contains
---

CA3 : aucun identifiant REC-nnn n'ouvre deux lignes de tableau du livrable.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
