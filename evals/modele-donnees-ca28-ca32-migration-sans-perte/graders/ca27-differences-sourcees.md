---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Différences *$(?:(?!^#{1,6} )[\s\S])*?^[-*] +(?![^\n]*(Source\s*:|supposé))[^\n]*$'
flags: m
match: not_contains
---

017-CA27 : chaque différence a sa source, ou la marque « supposé ».
