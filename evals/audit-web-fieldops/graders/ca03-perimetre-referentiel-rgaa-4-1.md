---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?RGAA 4\.1'
match: contains
---

CA3 : « Périmètre et méthode » indique le référentiel d'accessibilité RGAA 4.1.
