---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?code seul'
flags: "i"
match: contains
---

CA3 : « Périmètre et méthode » indique le mode « code seul ».
