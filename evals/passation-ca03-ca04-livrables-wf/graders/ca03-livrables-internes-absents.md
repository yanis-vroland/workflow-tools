---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:analyse-projet|chiffrage|revue-securite)'
match: not_contains
---

CA3 : les livrables à usage interne (analyse-projet, chiffrage, revue-securite) ne figurent pas dans « Documentation de référence ».
