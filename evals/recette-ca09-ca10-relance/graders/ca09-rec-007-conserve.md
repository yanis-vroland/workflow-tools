---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-007\s*\|[^\n]*002-ordres-de-travail\.md#CA1\b[^\n]*\|\s*conforme\s*\|\s*OK\s*\|'
match: contains
---

CA9 : REC-007 garde son ID, son statut et son commentaire.
