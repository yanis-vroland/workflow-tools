---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Plan d.action[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?(?:\bjours?\b|\bj/h\b|\b\d+(?:[.,]\d+)?\s*(?:j|h|jh)\b|jours?-hommes?|charge estim)'
flags: "i"
match: not_contains
---

CA13 : « Plan d'action » ne contient aucune estimation de charge en jours.
