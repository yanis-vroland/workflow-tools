---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?5b26289'
match: not_contains
---

CA12 : l'en-tête ne porte plus le commit de l'analyse précédente.
