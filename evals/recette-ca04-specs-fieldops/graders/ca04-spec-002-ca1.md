---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/specs/002-ordres-de-travail\.md#CA1\b'
match: contains
---

CA4 : le critère CA1 de docs/specs/002-ordres-de-travail.md est couvert par au
moins un cas, dont la colonne Source cite `docs/specs/002-ordres-de-travail.md#CA1`.
