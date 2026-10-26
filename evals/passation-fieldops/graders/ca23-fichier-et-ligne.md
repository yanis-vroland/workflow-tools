---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?deploy\.yml[^\n\d]{0,15}(?:29|30|31|33|44|45|46|48)\b'
match: contains
---

CA23 : le signalement cite le fichier et la ligne (`.github/workflows/deploy.yml`, lignes 29 à 33 et 44 à 48).
