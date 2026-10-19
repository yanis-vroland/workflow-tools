---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?\b2fc99c0'
match: contains
---

CA15 : l'en-tête donne le commit analysé (2fc99c0), même avec des modifications non commitées.
