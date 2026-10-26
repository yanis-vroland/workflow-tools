---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?(?:\bCSP\b|\bCORS\b|Content-Security-Policy|en-t[êe]tes? (?:HTTP )?de s[ée]curit[ée]|localStorage|\bJWT\b|injection SQL)))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

Hors périmètre (spec 011) : aucun constat ne porte sur la sécurité (en-têtes de sécurité, CSP, CORS, stockage du jeton, injection) : c'est le rôle de wf-revue-securite.
