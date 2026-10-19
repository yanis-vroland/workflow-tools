---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?\b5b26289\b'
match: contains
---

CA20 : l'en-tête donne le commit analysé (`git rev-parse --short HEAD`,
déterministe pour ce scaffold : 5b26289).
