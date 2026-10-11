---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Effort de reprise[^\n]*\n(?:(?!^#+ [^\n]*Points non déterminés)[\s\S])*?(?:faible|moyen|élevé)'
flags: mi
match: contains
---

CA9 : « Effort de reprise » donne une estimation qualitative (faible, moyen, élevé).
