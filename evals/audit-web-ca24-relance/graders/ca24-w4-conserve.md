---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:\n#{3,4} [^\n]*\bW4\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)11\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:NewIntervention\.tsx\x60?(?:\s*[:,]\s*|\s*\(\s*|\s+)(?:l\.|lignes?|L)?\s*(?:\d+\s*(?:,|et|à|-)\s*)*25(?!\d))))'
flags: "i"
match: contains
---

CA24 : le constat toujours présent (champ sans libellé, NewIntervention.tsx ligne 25) garde W4.
