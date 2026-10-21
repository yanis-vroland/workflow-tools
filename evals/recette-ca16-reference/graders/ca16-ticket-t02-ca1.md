---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/wf/specs-tickets\.md#T02-CA1\b'
match: contains
---

CA16 : le critère CA1 du ticket T02, modifié depuis la référence produit au moins un cas (`docs/wf/specs-tickets.md#T02-CA1`).
