---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?5b26289(?:(?!\n#+ [^\n]*Synthèse)[\s\S])*?modifications non commitées'
match: contains
---

CA13 : la mention « modifications non commitées » suit le commit dans l'en-tête.
