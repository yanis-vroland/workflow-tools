---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?\b5b26289'
match: contains
---

CA15 : l'en-tête donne le commit analysé (`git rev-parse --short HEAD` de FieldOps, déterministe : 5b26289).
