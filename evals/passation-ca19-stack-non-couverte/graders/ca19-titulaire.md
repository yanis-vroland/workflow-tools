---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?titulaire du compte\s*:\s*à compléter'
match: contains
---

CA7 : le service porte le champ « titulaire du compte : à compléter ».
