---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '^\| *C01 *\|[^|\n]*\| *B01 *\| *2(?:,0)? *(?:j)? *\| *3(?:,0)? *(?:j)? *\|'
flags: m
match: contains
---

005-CA18 : B01 est inchangé dans le cadrage ; la tâche C01 garde son identifiant, son besoin et ses estimations (2 et 3 jours).
