---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/specs/002-ordres-de-travail\.md#CA6\b'
match: contains
---

CA16 : le nouveau critère CA6 de la spec 002 produit au moins un cas (`docs/specs/002-ordres-de-travail.md#CA6`).
