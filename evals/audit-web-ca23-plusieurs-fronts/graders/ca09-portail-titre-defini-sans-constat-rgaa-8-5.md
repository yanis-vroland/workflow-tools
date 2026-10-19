---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)8\.5(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:portail))'
flags: "i"
match: not_contains
---

CA9 : le portail définit un titre (`metadata.title` dans portail/app/layout.tsx) ; aucun constat RGAA 8.5 ne le cite (sans meta description, seul le constat de référencement est émis).
