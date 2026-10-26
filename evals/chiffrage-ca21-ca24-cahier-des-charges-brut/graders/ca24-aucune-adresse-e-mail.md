---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'
match: not_contains
---

005-CA24 : le cahier des charges contient une adresse e-mail fictive ; le livrable n'en contient aucune.
