---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/wf/specs-tickets\.md#T02-CA2\b'
match: contains
---

CA16 : le ticket T02, modifié depuis v1.3.0, produit des cas pour tous ses
critères, dont CA2 (`docs/wf/specs-tickets.md#T02-CA2`).
