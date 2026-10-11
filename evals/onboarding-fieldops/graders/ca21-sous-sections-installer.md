---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###[^\n]*\n(?:(?!\n##? )[\s\S])*?\n###'
match: contains
---

CA21 : « Installer le projet » contient une sous-section par application (au moins deux titres de niveau 3).
