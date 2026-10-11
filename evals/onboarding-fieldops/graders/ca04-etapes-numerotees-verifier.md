---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*V[ée]rifier l.installation[^\n]*\n(?:(?!\n##? )[\s\S])*?\n *1\. '
match: contains
---

CA4 : « Vérifier l'installation » est rédigée en étapes numérotées.
