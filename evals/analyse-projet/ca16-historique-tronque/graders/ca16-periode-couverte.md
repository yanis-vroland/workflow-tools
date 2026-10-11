---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2026-08-26|26 août 2026|26/08/2026)'
flags: m
match: contains
---

CA16 : « Activité du dépôt » précise le début de la période réellement couverte (2026-08-26).
