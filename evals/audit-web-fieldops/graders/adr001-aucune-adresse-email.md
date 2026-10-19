---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '[\w.+-]+@[\w-]+(?:\.[\w-]+)+'
match: not_contains
---

ADR-001 : aucune adresse e-mail (de contributeur ou autre) dans le livrable.
