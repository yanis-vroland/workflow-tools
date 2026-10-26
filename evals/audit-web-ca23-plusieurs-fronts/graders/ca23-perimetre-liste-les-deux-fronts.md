---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?=(?:(?!\n#{1,2} )[\s\S])*?portail)(?=(?:(?!\n#{1,2} )[\s\S])*?src/web)'
flags: "i"
match: contains
---

CA23 : « Périmètre et méthode » liste les deux applications auditées (src/web/ et portail/).
