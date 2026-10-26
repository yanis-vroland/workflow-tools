---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Périmètre et méthode[^\n]*\n(?=(?:(?!\n#{1,2} )[\s\S])*?(?:legacy-php|PHP))(?=(?:(?!\n#{1,2} )[\s\S])*?non couverte?)'
flags: "i"
match: contains
---

CA22 : « Périmètre et méthode » signale les gabarits PHP (legacy-php/) comme « non couvert ».
