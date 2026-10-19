---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:[\w.+-]+@[\w-]+(?:\.[\w-]+)+))(?=[\s\S]*?wf-audit-web)'
match: contains
---

ADR-001 : aucune adresse e-mail (de contributeur ou autre) dans le livrable.
