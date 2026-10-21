---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-0(?:0\d|1[0-2])\s*\|[^\n]*(?:002-ordres-de-travail\.md#CA[24]\b|003-export-pdf\.md)|2026-09-15'
match: not_contains
---

CA9 : aucun critère sans cas dans le cahier précédent (002#CA2, 002#CA4, spec
003) ne reçoit un identifiant déjà utilisé (REC-001 à REC-012).
