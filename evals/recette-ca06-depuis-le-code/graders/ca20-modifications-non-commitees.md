---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?modifications non commit[ée]es'
flags: i
match: contains
---

CA20 : arbre de travail modifié, l'en-tête porte la mention « modifications non commitées ».
