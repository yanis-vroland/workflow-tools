---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)1\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:InterventionList\.tsx\x60?(?:\s*[:,]\s*|\s*\(\s*|\s+)(?:l\.|lignes?|L)?\s*(?:\d+\s*(?:,|et|à|-)\s*)*34(?!\d)))'
flags: "i"
match: contains
---

CA6 : un constat cite le critère RGAA 1.1 avec `src/web/pages/InterventionList.tsx` ligne 34.
