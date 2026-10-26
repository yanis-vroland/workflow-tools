---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C05 *\|[^|\n]*\| *B04 *\| *2(?:,0)? *(?:j)? *\| *3(?:,0)? *(?:j)? *\|'
flags: m
match: contains
---

005-CA18 : la tâche C05 (B04, inchangé) garde son identifiant et ses estimations (2 et 3 jours).
