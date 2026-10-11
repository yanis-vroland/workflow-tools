---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?make install\b'
match: contains
---

CA18 : l'installation est tirée du Makefile (`make install`).
