---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Règles de gestion *$(?:(?!^#{1,6} )[\s\S])*?\bRG01\b'
flags: m
match: contains
---

017-CA7 : « Règles de gestion » contient au moins une règle identifiée `RG01`.
