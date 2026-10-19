---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '###? [^\n]*Crit[èe]res non recettables manuellement(?:(?!\n##? |\n### )[\s\S])*specs-tickets\.md#T02-CA3\b'
match: contains
---

CA11 : le critère T02-CA3 (cache mémoire côté serveur, comportement interne) est
listé sous « Critères non recettables manuellement » avec sa source.
