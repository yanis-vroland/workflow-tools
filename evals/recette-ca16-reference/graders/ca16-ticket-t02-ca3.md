---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/wf/specs-tickets\.md#T02-CA3\b'
match: contains
---

CA16 : le nouveau critère CA3 du ticket T02 produit au moins un cas (`docs/wf/specs-tickets.md#T02-CA3`).
