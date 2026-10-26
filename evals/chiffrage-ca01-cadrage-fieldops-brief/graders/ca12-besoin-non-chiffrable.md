---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Exclusions *$(?:(?!^#{1,6} +(\d+\.? +)?Risques *$)[\s\S])*?B07[^\n]*non chiffrable en l[''’]état'
flags: m
match: contains
---

005-CA12 : le besoin trop imprécis B07 figure dans « Exclusions » avec la mention « non chiffrable en l'état ».
