---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '\bC\d{2}\b'
match: not_contains
---

006-CA9 : sans livrable de chiffrage, aucune tâche `Cnn` n'est citée.
