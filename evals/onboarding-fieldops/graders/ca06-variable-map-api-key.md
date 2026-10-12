---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\bMAP_API_KEY\b'
match: contains
---

CA6 : l'étape de configuration de « Installer le projet » liste la variable MAP_API_KEY (`.env.example`).
