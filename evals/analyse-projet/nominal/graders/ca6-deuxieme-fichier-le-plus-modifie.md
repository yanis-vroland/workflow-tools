---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:src/domain/invoice\.ts[^\n]*\d|\d[^\n]*src/domain/invoice\.ts)'
flags: m
match: contains
---

CA6 : src/domain/invoice.ts, deuxième point chaud, figure avec son nombre de commits.
