---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Référencement[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:portail))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:description))'
flags: "i"
match: contains
---

CA9 : un constat de référencement signale l'absence de meta description du portail (`metadata` de portail/app/layout.tsx sans description).
