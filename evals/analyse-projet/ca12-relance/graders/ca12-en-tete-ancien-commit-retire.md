---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?2fc99c0'
match: not_contains
---

CA12 : l'en-tête ne porte plus le commit de l'analyse précédente.
