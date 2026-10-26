---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?(?:compression|cache)'
flags: "i"
match: contains
---

CA28 : « Points non déterminés » mentionne ce qui relève de l'hébergeur (compression, cache).
