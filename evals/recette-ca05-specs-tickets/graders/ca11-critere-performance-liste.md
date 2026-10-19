---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Crit[èe]res non recettables manuellement(?:(?!\n##? |\n### )[\s\S])*004-liste-des-interventions\.md#CA2\b'
match: contains
---

CA11 : le critère CA2 de la spec 004 (performance mesurée par un test de charge)
est listé sous « Critères non recettables manuellement » avec sa source.
