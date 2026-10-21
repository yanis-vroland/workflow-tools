---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:\n\|\s*REC-003\s*\|[^\n]*001-interventions\.md#CA3\b[^\n]*\|\s*bloqué\s*\|\s*Liste vide sur l.environnement de recette, données à recharger\s*\|)'
match: contains
---

CA9 : REC-003 garde son ID, son statut « bloqué » et son commentaire.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
