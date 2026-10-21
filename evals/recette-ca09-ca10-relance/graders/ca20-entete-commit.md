---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?\b355fc68\b)'
match: contains
---

CA20 : l'en-tête donne le commit analysé (`git rev-parse --short HEAD`,
déterministe pour ce scaffold : 355fc68).

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
