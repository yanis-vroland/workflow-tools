---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?analyse-projet'
match: contains
---

CA13 : l'en-tête (avant « Synthèse ») indique l'outil.
