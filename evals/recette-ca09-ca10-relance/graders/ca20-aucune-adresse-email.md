---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b)|2026-09-15'
match: not_contains
---

CA20 et CA15 : le livrable ne contient aucune adresse e-mail (contributeurs
`@example.invalid` de l'historique et comptes de démonstration compris).

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
