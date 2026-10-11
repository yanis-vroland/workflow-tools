---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Qualité et tests[^\n]*\n(?:(?!^#+ [^\n]*Sécurité)[\s\S])*?src/domain/scheduling\.ts'
flags: m
match: contains
---

CA5 : « Qualité et tests » cite src/domain/scheduling.ts, qu'aucun test n'importe ni ne nomme.
