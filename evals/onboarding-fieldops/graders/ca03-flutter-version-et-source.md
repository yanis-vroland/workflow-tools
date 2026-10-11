---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Avant de commencer[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*3\.13\.9)(?=[^\n]*\.fvmrc)'
match: contains
---

CA3 : « Avant de commencer » donne Flutter 3.13.9 avec sa source `mobile/.fvmrc`, sur la même ligne.
