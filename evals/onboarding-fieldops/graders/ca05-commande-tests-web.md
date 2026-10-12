---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*V[ée]rifier l.installation[^\n]*\n(?:(?!\n##? )[\s\S])*?npm (?:run )?test\b'
match: contains
---

CA5 : « Vérifier l'installation » donne la commande de tests de l'application web (`npm test`, script `test` de `package.json`).
