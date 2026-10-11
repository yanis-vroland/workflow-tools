---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Activité du dépôt[^\n]*\n(?:(?!^#+ [^\n]*Qualité et tests)[\s\S])*?(?:src/api/routes/interventions\.ts[^\n]*\d|\d[^\n]*src/api/routes/interventions\.ts)'
flags: m
match: contains
---

CA6 : le fichier le plus souvent modifié sur 12 mois (src/api/routes/interventions.ts) figure avec son nombre de commits. Le nombre exact n'est pas figé : il dépend de la date d'exécution (fenêtre glissante de 12 mois).
