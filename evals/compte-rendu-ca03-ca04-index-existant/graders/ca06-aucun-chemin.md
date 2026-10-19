---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: '\.\./|reunions/|/Users/|/home/|/tmp/|/private/|/var/|/root/'
match: not_contains
---

007-CA6 (amendement 1) : aucun chemin vers les notes, relatif ou absolu, n'apparaît dans le compte rendu.
