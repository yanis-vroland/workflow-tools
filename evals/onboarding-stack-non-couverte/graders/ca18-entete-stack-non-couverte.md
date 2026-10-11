---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '^(?:(?!\n##? [^\n]*Avant de commencer)[\s\S])*?stack Python non couverte en v1'
flags: "i"
match: contains
---

CA18 : l'en-tête indique « stack Python non couverte en v1 ».
