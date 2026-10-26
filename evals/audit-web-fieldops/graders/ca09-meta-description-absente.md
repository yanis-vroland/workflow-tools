---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Référencement[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:description))'
flags: "i"
match: contains
---

CA9 : un constat de la section « Référencement » porte sur la meta description absente de `src/web/index.html`.
