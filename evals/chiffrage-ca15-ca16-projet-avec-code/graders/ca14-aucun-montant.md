---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '€|\$|£|\b(?:EUR|USD|GBP|CHF|TJM|HT|TTC)\b|\beuros?\b|taux journalier'
flags: i
match: not_contains
---

005-CA14 : aucun montant ni taux journalier dans le livrable (le code de la fixture contient un service de paiement).
