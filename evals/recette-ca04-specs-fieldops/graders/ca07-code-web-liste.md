---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*`src/'
match: contains
---

CA7 : « Périmètre et sources » cite le code web lu, par un chemin sous src/.
