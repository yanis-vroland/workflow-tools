---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:(?:[ée]lev[ée]|moyen|faible)))))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA4 : chaque constat (titre « W<n> ») indique un niveau : élevé, moyen ou faible.
