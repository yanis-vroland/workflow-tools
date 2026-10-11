---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2026-09-29|29 septembre 2026|29/09/2026)'
flags: m
match: contains
---

CA20 : « Activité du dépôt » donne le dernier commit qui touche le sous-dossier (2026-09-29), pas celui du dépôt.
