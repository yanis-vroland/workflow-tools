---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?sentry'
flags: "i"
match: not_contains
---

CA19 : Sentry, repéré seulement par une dépendance (`requirements.txt`, import dans le code), n'est pas listé dans « Services tiers et accès ».
