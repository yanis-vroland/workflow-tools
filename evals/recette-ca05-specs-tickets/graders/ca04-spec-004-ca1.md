---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*docs/specs/004-liste-des-interventions\.md#CA1\b'
match: contains
---

CA4 : le critère CA1 (pagination, vérifiable à la main) de la spec 004 est couvert par un cas.
