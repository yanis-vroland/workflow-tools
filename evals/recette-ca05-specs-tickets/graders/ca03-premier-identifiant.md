---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|'
match: contains
---

CA3 : les cas portent des identifiants de la forme REC-001, REC-002…
