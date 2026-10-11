---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Lancer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?make run\b'
match: contains
---

CA18 : le lancement est tiré du Makefile (`make run`).
