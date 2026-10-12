---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Se rep[ée]rer dans le code[^\n]*\n(?:(?!\n##? )[\s\S])*?\n *5\. '
match: contains
---

CA8 : le parcours de lecture compte au moins 5 fichiers numérotés.
