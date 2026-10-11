---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Dette et risques[^\n]*\n(?:(?!^#+ [^\n]*Effort de reprise)[\s\S])*?(?:src/api/routes/interventions\.ts[\s\S]{0,400}?(?:élevé|moyen|faible)|(?:élevé|moyen|faible)[\s\S]{0,400}?src/api/routes/interventions\.ts)'
flags: mi
match: contains
---

CA8 : le risque portant sur src/api/routes/interventions.ts a un niveau (élevé, moyen ou faible).
