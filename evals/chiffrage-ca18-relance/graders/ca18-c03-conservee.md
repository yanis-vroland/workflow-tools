---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C03 *\|[^|\n]*\| *B02 *\| *1(?:,0)? *(?:j)? *\| *1,5 *(?:j)? *\|'
flags: m
match: contains
---

005-CA18 : la tâche C03 (B02, inchangé) garde son identifiant et ses estimations (1 et 1,5 jour).
