---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '2026-09-15'
match: not_contains
---

Témoin : le livrable a été réécrit (la date de la campagne précédente,
2026-09-15, a été remplacée). Sans lui, les vérifications de conservation
réussiraient sur le livrable précédent intact.
