---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer[^\n]*\n(?:(?!\n##? )[\s\S])*?version non déterminée'
match: contains
---

CA3 : un outil requis sans version fixée (ex. fvm, exigé par `mobile/README.md`) porte la mention « version non déterminée ».
