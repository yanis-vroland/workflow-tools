---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?=(?:(?!\n##? )[\s\S])*?Stack technique)(?=(?:(?!\n##? )[\s\S])*?Architecture)(?=(?:(?!\n##? )[\s\S])*?Installation et lancement)(?=(?:(?!\n##? )[\s\S])*?Configuration)'
match: contains
---

CA4 : « Documentation de référence » nomme les sections « Stack technique », « Architecture », « Installation et lancement » et « Configuration ».
