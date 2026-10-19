---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'modifications non commitées'
flags: "i"
match: not_contains
---

CA21 : arbre de travail propre, donc pas de mention « modifications non commitées ».
