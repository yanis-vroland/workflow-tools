---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?commitlint\.config\.js'
match: contains
---

CA9 : la configuration commitlint, qui vérifie le format des commits, est citée
dans « Contribuer » avec son fichier, `commitlint.config.js`.
