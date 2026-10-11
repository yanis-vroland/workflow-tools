---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?c06ac92'
match: contains
---

CA12 : l'en-tête porte le commit actuel (c06ac92, commit du livrable précédent créé par le scaffold, déterministe).
