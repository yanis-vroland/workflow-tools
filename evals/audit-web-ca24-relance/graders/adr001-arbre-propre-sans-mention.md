---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: 'modifications non commitées'
flags: "i"
match: not_contains
---

ADR-001 : arbre de travail propre, donc pas de mention « modifications non commitées ».
