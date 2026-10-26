---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###'
match: contains
---

CA20 : « Services tiers et accès » contient une sous-section par application (au moins deux titres de niveau 3).
