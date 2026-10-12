---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?non applicable'
flags: mi
match: contains
---

CA15 : « Activité du dépôt » indique « non applicable ».
