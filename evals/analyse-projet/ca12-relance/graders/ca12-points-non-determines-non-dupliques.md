---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Points non déterminés'
flags: m
match: count:1
---

CA12 : une seule section « Points non déterminés ».
