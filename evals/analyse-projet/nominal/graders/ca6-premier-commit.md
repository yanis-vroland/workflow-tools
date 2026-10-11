---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2025-08-04|4 août 2025|04/08/2025)'
flags: m
match: contains
---

CA6 : « Activité du dépôt » indique la date du premier commit (2025-08-04).
