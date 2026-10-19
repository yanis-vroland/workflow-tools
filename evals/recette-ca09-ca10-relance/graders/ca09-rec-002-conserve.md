---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-002\s*\|[^\n]*001-interventions\.md#CA2\b[^\n]*\|\s*non conforme\s*\|\s*Aucun message affiché, le formulaire se vide\s*\|'
match: contains
---

CA9 : REC-002 garde son ID, son statut « non conforme » et son commentaire.
