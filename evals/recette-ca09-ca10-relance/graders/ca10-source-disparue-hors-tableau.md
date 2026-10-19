---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:\n\|\s*REC-\d{3}\s*\|[^\n]*(?:005-notifications-sms\.md|002-ordres-de-travail\.md#CA7\b))|2026-09-15'
match: not_contains
---

CA10 : aucun cas du tableau ne cite une source disparue (spec 005 supprimée,
critère 002#CA7 inexistant).

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
