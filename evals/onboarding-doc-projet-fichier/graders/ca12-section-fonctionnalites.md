---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Pour aller plus loin[^\n]*\n(?:(?!\n##? )[\s\S])*?Fonctionnalités'
match: contains
---

CA12 : « Pour aller plus loin » nomme la section « Fonctionnalités ».
