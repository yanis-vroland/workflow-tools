---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '001-interventions\.md#CA(?:[7-9]|\d{2,})\b|002-ordres-de-travail\.md#CA(?:[6-9]|\d{2,})\b|003-export-pdf\.md#CA(?:[4-9]|\d{2,})\b'
match: not_contains
---

CA4 : aucune source ne cite un critère qui n'existe pas (001 a six critères, 002
en a cinq, 003 en a trois).
