---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?wf-onboarding'
match: contains
---

CA15 : l'en-tête nomme l'outil wf-onboarding.
