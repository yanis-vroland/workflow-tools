---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C02 *\|[^|\n]*\| *B01 *\| *1,5 *(?:j)? *\| *3(?:,0)? *(?:j)? *\|'
flags: m
match: contains
---

005-CA18 : la tâche C02 (B01, inchangé) garde son identifiant et ses estimations (1,5 et 3 jours).
