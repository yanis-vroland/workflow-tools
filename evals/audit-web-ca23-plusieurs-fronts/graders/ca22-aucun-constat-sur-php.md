---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?(?:legacy-php|\.php\b)'
flags: "i"
match: not_contains
---

CA22 : aucun constat n'est rapporté pour les gabarits PHP, malgré leurs défauts (img sans alt, html sans lang).
