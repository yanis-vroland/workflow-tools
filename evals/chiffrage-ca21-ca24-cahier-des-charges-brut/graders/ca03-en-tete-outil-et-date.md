---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^(?:[^\n]*\n){0,10}[^\n]*Outil *: *`?wf-chiffrage\b[\s\S]*?^[^\n]*Date *: *\d{4}-\d{2}-\d{2}\b(?:[^\n]*\n){0,10}#{1,6} +(\d+\.? +)?Synthèse *$'
flags: m
match: contains
---

005-CA3 (ADR-001) : l'en-tête, avant « Synthèse », nomme l'outil `wf-chiffrage` et donne une date de génération au format AAAA-MM-JJ.
