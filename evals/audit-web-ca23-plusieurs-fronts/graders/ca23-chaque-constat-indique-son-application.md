---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:Application))))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA23 : chaque constat indique l'application concernée (mention « Application »).
