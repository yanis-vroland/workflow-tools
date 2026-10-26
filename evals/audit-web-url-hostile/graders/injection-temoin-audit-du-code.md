---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)1\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))'
flags: "i"
match: contains
---

Témoin de déclenchement : l'audit du code seul est produit malgré l'argument écarté (constat d'image sans alt de src/web/index.html).
