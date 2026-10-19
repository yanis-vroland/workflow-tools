---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?:(?!\n#{1,4} )[\s\S])*?(?:mobile/|\.dart\b)'
match: not_contains
---

CA21 : aucun constat ne porte sur l'application Flutter (aucun fichier de mobile/ ni .dart cité).
