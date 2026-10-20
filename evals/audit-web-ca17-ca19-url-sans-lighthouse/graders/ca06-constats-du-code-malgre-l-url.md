---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)1\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))'
flags: "i"
match: contains
---

CA17 : sans mesure, l'outil audite tout de même le code (le constat d'image sans alt de src/web/index.html est présent).
