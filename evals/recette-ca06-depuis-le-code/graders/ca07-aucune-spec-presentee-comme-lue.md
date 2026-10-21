---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*P[ée]rim[èe]tre et sources(?:(?!\n##? )[\s\S])*docs/specs/[^\s`]+\.md'
match: not_contains
---

CA7 : « Périmètre et sources » ne cite aucune spec docs/specs/*.md : il n'en
existe plus dans le projet.
