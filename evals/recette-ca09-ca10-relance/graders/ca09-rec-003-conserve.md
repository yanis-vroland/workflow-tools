---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-003\s*\|[^\n]*001-interventions\.md#CA3\b[^\n]*\|\s*bloqué\s*\|\s*Liste vide sur l.environnement de recette, données à recharger\s*\|'
match: contains
---

CA9 : REC-003 garde son ID, son statut « bloqué » et son commentaire.
