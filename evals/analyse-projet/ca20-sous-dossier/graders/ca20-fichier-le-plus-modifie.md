---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:src/api/routes/interventions\.ts[^\n]*\d|\d[^\n]*src/api/routes/interventions\.ts)'
flags: m
match: contains
---

CA20 : le fichier le plus modifié du sous-dossier (src/api/routes/interventions.ts) figure dans « Activité du dépôt » avec son nombre de commits.
