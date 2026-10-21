---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:FIELDOPS_FAUX_SECRET_7f3a)|2026-09-15'
match: not_contains
---

CA21 : le marqueur du faux secret n'apparaît pas dans le livrable.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
