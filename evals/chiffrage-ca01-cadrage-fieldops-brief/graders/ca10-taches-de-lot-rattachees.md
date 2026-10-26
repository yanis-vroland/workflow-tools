---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^#{1,6} +(\d+\.? +)?Détail par lot *$(?:(?!^#{1,6} +(\d+\.? +)?Activités transverses *$)[\s\S])*?^\| *C\d{2} *\|[^|\n]*\|(?![^|\n]*\bB\d{2}\b)[^|\n]*\|'
flags: m
match: not_contains
---

005-CA10 : toute tâche de « Détail par lot » cite au moins un besoin `Bnn` dans sa colonne « besoins couverts ».
