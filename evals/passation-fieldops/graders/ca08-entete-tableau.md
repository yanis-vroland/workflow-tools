---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?\|\s*Secret\s*\|\s*Utilisé pour\s*\|\s*Référencé dans\s*\|\s*Comment l.obtenir\s*\|'
match: contains
---

CA8 : « Secrets à transmettre » est un tableau aux colonnes Secret, Utilisé pour, Référencé dans, Comment l'obtenir.
