---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?\n\|\s*REC-005\s*\|[^\n]*001-interventions\.md#CA5\b[^\n]*\|\s*conforme\s*\|\s*Vérifié avec le chef d.équipe\s*\|'
match: contains
---

CA9 : REC-005 garde son ID, sa source, son statut « conforme » et son commentaire, mot pour mot.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
