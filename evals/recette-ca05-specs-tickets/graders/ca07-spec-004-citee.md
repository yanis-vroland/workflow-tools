---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*docs/specs/004-liste-des-interventions\.md'
match: contains
---

CA7 : « Périmètre et sources » liste la spec 004 avec son chemin.
