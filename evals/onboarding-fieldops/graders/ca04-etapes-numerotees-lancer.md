---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Lancer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n *1\. '
match: contains
---

CA4 : « Lancer le projet » est rédigée en étapes numérotées.
