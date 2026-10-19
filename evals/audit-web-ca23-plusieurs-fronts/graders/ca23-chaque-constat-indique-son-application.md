---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:Application))'
flags: "i"
match: not_contains
---

CA23 : chaque constat indique l'application concernée (mention « Application »).
