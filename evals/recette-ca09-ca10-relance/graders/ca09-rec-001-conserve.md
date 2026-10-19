---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-001\s*\|[^\n]*001-interventions\.md#CA1\b[^\n]*\|\s*conforme\s*\|\s*RAS sur la recette du 12/09\s*\|'
match: contains
---

CA9 : REC-001 (source 001#CA1 toujours présente) garde son ID, son statut
« conforme » et son commentaire saisi à la main, mot pour mot.
