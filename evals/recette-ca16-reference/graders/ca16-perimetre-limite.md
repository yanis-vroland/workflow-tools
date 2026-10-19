---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*depuis la r[ée]f[ée]rence[^\n]*v1\.3\.0'
flags: i
match: contains
---

CA16 : « Périmètre et sources » indique que la campagne est limitée aux
changements depuis la référence v1.3.0.
