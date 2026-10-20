---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?\n\|\s*REC-008\s*\|[^\n]*002-ordres-de-travail\.md#CA3\b[^\n]*\|\s*à tester\s*\|\s*\s*\|'
match: contains
---

CA9 et CA8 : REC-008 garde son ID et sa source, reste « à tester » avec un commentaire vide.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
