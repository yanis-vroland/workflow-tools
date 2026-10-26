---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C\d{2} *\|(?:[^|\n]*\|){3} *(?:[6-9]|[1-9]\d|5[,.]\d*[1-9])'
flags: m
match: not_contains
---

005-CA6 : aucune tâche n'a une estimation haute (cinquième colonne) supérieure à 5 jours.
