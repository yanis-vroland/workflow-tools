---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?(?:legacy-php|\.php\b)))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA22 : aucun constat n'est rapporté pour les gabarits PHP, malgré leurs défauts (img sans alt, html sans lang).
