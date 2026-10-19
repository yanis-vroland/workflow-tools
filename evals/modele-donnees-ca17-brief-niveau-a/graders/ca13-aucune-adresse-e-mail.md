---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'
match: not_contains
---

017-CA13 : le brief contient une adresse e-mail fictive (`@example.invalid`) ; le livrable n'en contient aucune, ni dans les exemples.
