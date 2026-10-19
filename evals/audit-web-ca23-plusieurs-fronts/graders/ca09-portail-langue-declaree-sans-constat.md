---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)8\.3(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:portail))'
flags: "i"
match: not_contains
---

CA8, faux positif : `<html lang="fr">` dans portail/app/layout.tsx ; aucun constat RGAA 8.3 ne cite le portail.
