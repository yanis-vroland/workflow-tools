---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Documentation de r[ée]f[ée]rence[^\n]*\n(?:(?!\n##? )[\s\S])*?\]\((?:\./)?doc-projet/installation\.md\)'
match: contains
---

CA4 : en format dossier, « Installation et lancement » est renvoyée à `doc-projet/installation.md`.
