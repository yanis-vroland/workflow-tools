---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^[-*] +\**E\d\d\b(?![^\n]*(\bB0[1-6]\b|« [^»\n]+ »|supposé))[^\n]*$'
flags: m
match: not_contains
---

017-CA18 et CA4 : chaque entité cite un besoin `Bnn` du cadrage, une phrase citée, ou est marquée « supposé ».
