---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?wf-recette'
match: contains
---

CA20 : l'en-tête (avant « Périmètre et sources ») nomme l'outil wf-recette.
