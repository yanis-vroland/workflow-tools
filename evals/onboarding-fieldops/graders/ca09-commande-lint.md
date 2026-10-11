---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?npm run lint\b'
match: contains
---

CA9 : « Contribuer » donne la commande de lint `npm run lint` (`package.json`).
