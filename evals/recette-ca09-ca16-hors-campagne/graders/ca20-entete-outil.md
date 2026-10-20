---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?wf-recette)'
match: contains
---

CA20 : l'en-tête (avant « Périmètre et sources ») nomme l'outil wf-recette.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
