---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?ex[ée]cut'
match: contains
---

CA14 : l'en-tête du guide, avant « Avant de commencer », mentionne l'absence d'exécution des commandes.
