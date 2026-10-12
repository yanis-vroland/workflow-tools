---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*18\.19\.0)(?=[^\n]*\.nvmrc)'
match: contains
---

CA3 : « Avant de commencer » donne Node.js 18.19.0 avec sa source `.nvmrc`, sur la même ligne.
