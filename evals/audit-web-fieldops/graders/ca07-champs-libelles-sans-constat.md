---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)11\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:NewIntervention\.tsx\x60?(?:\s*[:,]\s*|\s*\(\s*|\s+)(?:l\.|lignes?|L)?\s*(?:\d+\s*(?:,|et|à|-)\s*)*2[47](?!\d)))'
flags: "i"
match: not_contains
---

CA7, faux positif : les champs des lignes 24 et 27 de NewIntervention.tsx ont un `<label htmlFor>` associé ; aucun constat RGAA 11.1 ne les cite.
