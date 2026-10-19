---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)8\.3(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:portail))))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA8, faux positif : `<html lang="fr">` dans portail/app/layout.tsx ; aucun constat RGAA 8.3 ne cite le portail.
