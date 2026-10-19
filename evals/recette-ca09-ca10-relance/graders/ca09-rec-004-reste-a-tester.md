---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-004\s*\|[^\n]*001-interventions\.md#CA4\b[^\n]*\|\s*à tester\s*\|\s*\|'
match: contains
---

CA9 et CA8 : REC-004 garde son ID, reste « à tester » avec un commentaire vide
(l'outil n'attribue jamais lui-même un autre statut).
