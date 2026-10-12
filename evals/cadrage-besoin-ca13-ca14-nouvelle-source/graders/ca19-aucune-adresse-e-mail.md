---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '[A-Za-z0-9._%+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'
match: not_contains
---

004-CA19 : l'e-mail du client contient deux adresses e-mail fictives ; le livrable n'en contient aucune.
