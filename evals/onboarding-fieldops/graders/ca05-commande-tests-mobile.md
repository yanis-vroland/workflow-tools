---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*V[ée]rifier l.installation[^\n]*\n(?:(?!\n##? )[\s\S])*?flutter test\b'
match: contains
---

CA5 : « Vérifier l'installation » donne la commande de tests de l'application mobile (`fvm flutter test`, `mobile/README.md`).
