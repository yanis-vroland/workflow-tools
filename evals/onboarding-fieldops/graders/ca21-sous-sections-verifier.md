---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*V[ée]rifier l.installation[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###'
match: contains
---

CA21 : « Vérifier l'installation » contient une sous-section par application.
