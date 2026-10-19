---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-(?:01[3-9]|0[2-9]\d|[1-9]\d\d)\s*\|[^\n]*002-ordres-de-travail\.md#CA2\b'
match: contains
---

CA9 : le critère 002#CA2, sans cas jusqu'ici, reçoit un identifiant jamais
utilisé (REC-013 ou au-delà ; REC-010 à REC-012 ont déjà servi).
