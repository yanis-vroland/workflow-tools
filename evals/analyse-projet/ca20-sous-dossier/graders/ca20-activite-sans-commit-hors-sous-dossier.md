---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:2026-10-0[1-6]|0?[1-6] octobre 2026|0[1-6]/10/2026)'
flags: m
match: not_contains
---

CA20 : « Activité du dépôt » ne cite aucune date des commits faits hors du sous-dossier (2026-10-01 à 2026-10-06, plateforme/).
