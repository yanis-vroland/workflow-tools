---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:modifications non commit[ée]es)|2026-09-15'
flags: i
match: not_contains
---

CA20 : arbre de travail propre, donc pas de mention « modifications non commitées ».

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
