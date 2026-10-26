---
type: regex
target: { source: file, path: "docs/wf/chiffrage.md" }
pattern: '€|\$|£|\b(?:EUR|USD|GBP|CHF|TJM|HT|TTC)\b|\beuros?\b|taux journalier|25 ?000'
flags: i
match: not_contains
---

005-CA14 : aucun montant ni taux journalier dans le livrable, alors que la réponse à Q05 du cadrage donne un budget en euros (25 000 € HT, 500 € par jour).
