---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW3\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)8\.5(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))'
flags: "i"
match: contains
---

CA24 : le constat toujours présent (page sans titre, RGAA 8.5) garde l'identifiant W3.
