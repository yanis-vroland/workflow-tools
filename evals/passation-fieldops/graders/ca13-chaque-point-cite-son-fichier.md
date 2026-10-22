---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)[ \t]*[-*|] (?![^\n]*`[^`\n]+`)(?![^\n]*\n[ \t]*\|[ \t]*:?-)[^\n]*'
match: not_contains
---

CA13 : chaque point de « Points d'attention » (puce ou ligne de tableau, hors ligne d'en-tête d'un tableau) cite le fichier qui l'établit, entre accents graves.
