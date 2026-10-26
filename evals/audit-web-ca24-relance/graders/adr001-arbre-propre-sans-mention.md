---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:modifications non commitées))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

ADR-001 : arbre de travail propre, donc pas de mention « modifications non commitées ».
