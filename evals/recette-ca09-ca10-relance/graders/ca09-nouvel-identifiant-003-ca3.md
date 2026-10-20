---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-(?:01[3-9]|0[2-9]\d|[1-9]\d\d)\s*\|[^\n]*003-export-pdf\.md#CA3\b|###? [^\n]*Crit[èe]res non recettables manuellement(?:(?!\n##? |\n### )[\s\S])*003-export-pdf\.md#CA3\b'
match: contains
---

CA9 : le critère `003-export-pdf.md#CA3`, sans cas dans le cahier précédent, reçoit
un identifiant jamais utilisé (REC-013 ou au-delà), ou est listé comme non
recettable manuellement.
