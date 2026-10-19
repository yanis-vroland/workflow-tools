---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:(?:[ée]lev[ée]|moyen|faible)))'
flags: "i"
match: not_contains
---

CA4 : chaque constat (titre « W<n> ») indique un niveau : élevé, moyen ou faible.
