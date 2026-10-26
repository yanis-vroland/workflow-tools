---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Hypothèses *$(?:(?!^#{1,6} +(\d+\.? +)?Exclusions *$)[\s\S])*?à partir de zéro'
flags: mi
match: contains
---

005-CA22 : dans la fixture FieldOps brief (aucun code source), « Hypothèses » indique qu'il s'agit d'un développement à partir de zéro.
