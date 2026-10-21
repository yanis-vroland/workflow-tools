---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: 'modifications non commitées'
flags: 'i'
match: not_contains
---

CA3 (ADR-001) : arbre de travail propre, donc pas de mention « modifications non commitées ».
