---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Performance[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:public/img/bandeau\.png))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:\d[\d\s\u202f\u00a0.,]*\s*(?:Ko|ko|kB|KiB|Kio|octets)\b))'
match: contains
---

CA10 : un constat de performance cite `public/img/bandeau.png` (259 523 octets) et sa taille.
