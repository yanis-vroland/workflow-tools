---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-(?!006\b)\d{3}\s*\|[^\n]*001-interventions\.md#CA1\b|2026-09-15'
match: not_contains
---

CA9 : le critère 001#CA1 garde l'identifiant REC-006 ; aucun nouvel
identifiant ne lui est attribué (ce qui perdrait les saisies de REC-006).
