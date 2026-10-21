---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:\n\|\s*REC-002\s*\|[^\n]*001-interventions\.md#CA2\b[^\n]*\|\s*non conforme\s*\|\s*Aucun message affiché, le formulaire se vide\s*\|)'
match: contains
---

CA9 : REC-002 garde son ID, son statut « non conforme » et son commentaire.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
