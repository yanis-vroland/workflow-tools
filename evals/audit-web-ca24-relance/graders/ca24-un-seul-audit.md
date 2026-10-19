---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)^(?![\s\S]*?(?:(?:^|\n)# [^\n]*[\s\S]*\n# ))(?=[\s\S]*?wf-audit-web)'
match: contains
---

CA24 : le livrable est mis à jour au lieu d'être dupliqué : un seul titre de niveau 1.
