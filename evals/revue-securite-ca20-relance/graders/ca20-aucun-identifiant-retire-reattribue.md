---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '(?:\n### |\|\s*)S(?:1|3|5|6|7|8|10|11)\b'
match: not_contains
---

CA20 : aucun identifiant retiré (S1, S3, S5, S6, S8, S10 et S11 avant cette exécution, S7 retiré par
elle) n'est réattribué, ni à un constat ni à une dépendance.
