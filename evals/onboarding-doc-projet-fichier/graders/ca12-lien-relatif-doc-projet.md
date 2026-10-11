---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Pour aller plus loin[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\./)?doc-projet\.md(?:#[^)]*)?\)'
match: contains
---

CA12 : « Pour aller plus loin » renvoie à `docs/wf/doc-projet.md` par un lien relatif (depuis docs/wf/).
