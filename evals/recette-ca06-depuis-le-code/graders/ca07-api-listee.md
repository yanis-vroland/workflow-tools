---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*`src/api'
match: contains
---

CA7 : « Périmètre et sources » cite le code de l’API lu (src/api ou ses routes).
