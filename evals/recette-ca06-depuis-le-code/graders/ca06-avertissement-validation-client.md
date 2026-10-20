---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*valid[ée]s? par le client'
match: contains
---

CA6 : « Périmètre et sources » avertit que les résultats attendus doivent être validés par le client avant la recette.
