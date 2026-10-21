---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:\n\|\s*REC-\d{3}\s*\|)'
match: contains
---

CA3 : les cas portent des identifiants de la forme REC-001, REC-002…

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
