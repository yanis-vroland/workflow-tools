---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/wf/specs-tickets\.md#T01-CA1\b'
match: contains
---

CA5 : le critère T01-CA1 du livrable wf-specs-tickets est couvert par au moins un
cas, dont la colonne Source cite le fichier, le ticket et le critère
(`docs/wf/specs-tickets.md#T01-CA1`).
