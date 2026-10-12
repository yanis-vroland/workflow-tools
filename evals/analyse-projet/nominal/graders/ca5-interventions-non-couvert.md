---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Qualité et tests[^\n]*\n(?:(?!^#+ [^\n]*Sécurité)[\s\S])*?src/api/routes/interventions\.ts'
flags: m
match: contains
---

CA5 : « Qualité et tests » cite src/api/routes/interventions.ts, non couvert.
