---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*003-export-pdf\.md#CA1\b|###? [^\n]*Crit[èe]res non recettables manuellement(?:(?!\n##? |\n### )[\s\S])*003-export-pdf\.md#CA1\b'
match: contains
---

CA13 : le critère CA1 de la spec en brouillon (`docs/specs/003-export-pdf.md`)
est couvert par un cas du tableau, ou listé sous « Critères non recettables
manuellement ».
