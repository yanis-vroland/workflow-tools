---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?hors git'
match: contains
---

CA15 : le projet n'est pas un dépôt git, l'en-tête porte la mention « hors git ».
