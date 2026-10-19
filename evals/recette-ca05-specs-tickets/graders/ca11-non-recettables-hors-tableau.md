---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*(?:specs-tickets\.md#T02-CA3\b|004-liste-des-interventions\.md#CA2\b)'
match: not_contains
---

CA11 : les deux critères non vérifiables à la main ne produisent aucun cas de recette.
