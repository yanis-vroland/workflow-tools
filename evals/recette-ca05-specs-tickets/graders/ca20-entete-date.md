---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?\d{4}-\d{2}-\d{2}'
match: contains
---

CA20 : l'en-tête donne la date (AAAA-MM-JJ).
