---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:2026-09-15))(?=[\s\S]*?wf-audit-web)'
match: contains
---

CA24 : la date de l'audit précédent (2026-09-15) est remplacée.
