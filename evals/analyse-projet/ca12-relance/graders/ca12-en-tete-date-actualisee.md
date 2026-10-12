---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?2026-10-01'
match: not_contains
---

CA12 : l'en-tête ne porte plus la date de l'analyse précédente.
