---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Dette et risques[^\n]*\n(?:(?!^#+ [^\n]*Effort de reprise)[\s\S])*?(?:src/api/routes/interventions\.ts[^\n]*?(?:élevé|moyen|faible)|(?:élevé|moyen|faible)[^\n]*?src/api/routes/interventions\.ts)'
flags: mi
match: contains
---

CA8 : le risque portant sur src/api/routes/interventions.ts a un niveau (élevé, moyen ou faible), sur la même ligne que le chemin : un niveau qui appartient à un autre risque, quelques lignes plus loin, ne compte pas.
