---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/specs/002-ordres-de-travail\.md#CA4\b'
match: contains
---

CA16 : la spec 002, modifiée depuis v1.3.0, produit des cas pour tous ses
critères, dont CA4 (`docs/specs/002-ordres-de-travail.md#CA4`).
