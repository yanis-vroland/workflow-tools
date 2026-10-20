---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-(?:00[89]|0[1-9]\d|[1-9]\d\d)\s*\|[^\n]*001-interventions\.md#CA7\b'
match: contains
---

CA9 : le nouveau critère 001#CA7 reçoit un identifiant jamais utilisé
(REC-008 ou au-delà ; REC-001 à REC-007 ont déjà servi).
