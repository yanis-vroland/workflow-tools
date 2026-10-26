---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?requirements\.txt'
match: not_contains
---

CA19 : « Services tiers et accès » se limite aux indices hors dépendances : `requirements.txt` n'y est pas cité comme indice.
