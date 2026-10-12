---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer[^\n]*\n(?:(?!\n##? )[\s\S])*?18\.19\.0'
match: contains
---

CA16 : la version actuelle de Node.js (18.19.0, `.nvmrc`) figure dans le guide mis à jour.
