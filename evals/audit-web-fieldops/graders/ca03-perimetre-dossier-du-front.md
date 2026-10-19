---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?src/web'
match: contains
---

CA3 : « Périmètre et méthode » cite le dossier du front web analysé (src/web/).
