---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: 'docs/specs/[^\s|`]*#CA|specs-tickets\.md#T'
match: not_contains
---

CA6 : aucun cas ne cite un critère de spec ou de ticket : il n'en existe aucun
dans le projet (les specs retirées ne restent que dans l'historique git).
