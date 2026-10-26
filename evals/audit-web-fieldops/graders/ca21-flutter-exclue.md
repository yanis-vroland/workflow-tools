---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?=(?:(?!\n#{1,2} )[\s\S])*?Flutter)(?=(?:(?!\n#{1,2} )[\s\S])*?mobile)(?=(?:(?!\n#{1,2} )[\s\S])*?(?:exclue?|non couverte?))'
flags: "i"
match: contains
---

CA21 : « Périmètre et méthode » cite l'application Flutter (mobile/) comme exclue.
