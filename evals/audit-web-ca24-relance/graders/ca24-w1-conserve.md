---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW1\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)1\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:src/web/index\.html\x60?(?:\s*[:,]\s*|\s*\(\s*|\s+)(?:l\.|lignes?|L)?\s*(?:\d+\s*(?:,|et|à|-)\s*)*10(?!\d)))'
flags: "i"
match: contains
---

CA24 : le constat toujours présent (image sans alt, src/web/index.html ligne 10) garde l'identifiant W1.
