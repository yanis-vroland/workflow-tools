---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*docs/wf/specs-tickets\.md'
match: contains
---

CA7 : « Périmètre et sources » liste le livrable wf-specs-tickets avec son chemin.
