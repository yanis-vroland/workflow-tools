---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '(\+33|\b0)\s?[1-9]([ .-]?\d{2}){4}\b'
match: not_contains
---

006-CA22 : le cahier des charges contient des numéros de téléphone factices ; le livrable n'en contient aucun.
