---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*`mobile/'
match: contains
---

CA7 : « Périmètre et sources » cite le code mobile lu, par un chemin sous mobile/.
