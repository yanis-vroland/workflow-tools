---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Pour aller plus loin[^\n]*\n(?:(?!\n##? )[\s\S])*?/wf-doc-projet\b'
match: contains
---

CA12 : sans livrable wf-doc-projet, « Pour aller plus loin » suggère de lancer `/wf-doc-projet`.
