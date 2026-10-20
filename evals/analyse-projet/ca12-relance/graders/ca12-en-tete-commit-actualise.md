---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?487e618'
match: contains
---

CA12 : l'en-tête porte le commit actuel (487e618, commit du livrable précédent créé par le scaffold, déterministe).
