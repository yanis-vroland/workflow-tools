---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|[^\n]*(?:005-notifications-sms\.md|002-ordres-de-travail\.md#CA7\b)'
match: not_contains
---

CA10 : aucun cas du tableau ne cite une source disparue (spec 005 supprimée,
critère 002#CA7 inexistant).
