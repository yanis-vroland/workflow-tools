---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^### +Relations *$(?:(?!^#{1,6} )[\s\S])*?^[-*] +(?=[^\n]* — )(?![^\n]*Cardinalités\s*:[^\n]*(RG\d\d|supposé))[^\n]*$'
flags: m
match: not_contains
---

017-CA7 : chaque relation indique les cardinalités et la règle `RGnn` dont elles découlent, ou la marque « supposé ».
