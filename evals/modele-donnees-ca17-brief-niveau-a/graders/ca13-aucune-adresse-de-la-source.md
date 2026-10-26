---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: 'projet\.sdt'
match: not_contains
---

017-CA13 : l'adresse e-mail du brief (`projet.sdt@…`) n'apparaît pas dans le livrable, même tronquée ou dans une citation.
