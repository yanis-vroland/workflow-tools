---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Référencement[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:titre|title)))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:\broutes?\b[^\n]{0,15}?\x60?/(?![\w/])|toutes les (?:routes|vues|pages))))'
flags: "i"
match: contains
---

CA9 : le constat de référencement sur le titre absent cite le fichier `src/web/index.html` et la route concernée.
