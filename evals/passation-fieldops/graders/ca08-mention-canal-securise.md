---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?à transmettre par un canal sécurisé, hors de ce document'
match: contains
---

CA8 : la section porte la mention « à transmettre par un canal sécurisé, hors de ce document ».
