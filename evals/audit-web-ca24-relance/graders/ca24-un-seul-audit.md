---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '(?:^|\n)# [^\n]*[\s\S]*\n# '
match: not_contains
---

CA24 : le livrable est mis à jour au lieu d'être dupliqué : un seul titre de niveau 1.
