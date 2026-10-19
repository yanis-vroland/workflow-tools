---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*comportement actuel du code'
flags: i
match: contains
---

CA6 : « Périmètre et sources » avertit que les résultats attendus décrivent le
comportement actuel du code.
