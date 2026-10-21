---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '\bC(1[4-9]|[2-9]\d|00)\b'
match: not_contains
---

006-CA9 : seules les tâches C01 à C13 du chiffrage sont citées ; aucun identifiant de tâche n'est inventé.
