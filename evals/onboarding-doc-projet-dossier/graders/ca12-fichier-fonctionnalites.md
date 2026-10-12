---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Pour aller plus loin[^\n]*\n(?:(?!\n##? )[\s\S])*?doc-projet/fonctionnalites\.md'
match: contains
---

CA12 : format dossier, « Pour aller plus loin » nomme `fonctionnalites.md`.
