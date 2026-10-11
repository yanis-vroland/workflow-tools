---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\bJWT_SECRET\b'
match: contains
---

CA6 : l'étape de configuration de « Installer le projet » liste la variable JWT_SECRET (`.env.example`).
