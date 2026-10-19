---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: 'modifications non commit[ée]es'
flags: i
match: not_contains
---

CA20 : arbre de travail propre, donc pas de mention « modifications non commitées ».
