---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*(?:001-interventions\.md|003-export-pdf\.md|#T01-|#T03-)'
match: not_contains
---

CA16 : la spec 001, la spec 003 et les tickets T01 et T03, inchangés depuis
v1.3.0, ne produisent aucun cas.
