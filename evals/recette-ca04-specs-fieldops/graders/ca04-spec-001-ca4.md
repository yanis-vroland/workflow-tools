---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/specs/001-interventions\.md#CA4\b'
match: contains
---

CA4 : le critère CA4 de docs/specs/001-interventions.md est couvert par au moins
un cas, dont la colonne Source cite le chemin de la spec et le critère
(`docs/specs/001-interventions.md#CA4`).
