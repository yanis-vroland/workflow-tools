---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Dette et risques[^\n]*\n(?:(?!^#+ [^\n]*Effort de reprise)[\s\S])*?src/api/routes/interventions\.ts'
flags: m
match: contains
---

CA7 : src/api/routes/interventions.ts, dans le top 10 et non couvert, apparaît dans « Dette et risques ».
