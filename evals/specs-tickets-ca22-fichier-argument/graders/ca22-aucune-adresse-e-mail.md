---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'
match: not_contains
---

006-CA22 : le cahier des charges contient des adresses e-mail fictives (`@example.invalid`) ; le livrable n'en contient aucune.
