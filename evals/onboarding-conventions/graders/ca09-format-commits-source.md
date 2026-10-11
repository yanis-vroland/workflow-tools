---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*(?:Conventional Commits|<type>\(<port[ée]e>\)))(?=[^\n]*(?:CONTRIBUTING\.md|commitlint\.config\.js))'
flags: i
match: contains
---

CA9 : le format des commits (Conventional Commits, `<type>(<portée>): <résumé>`)
est repris dans « Contribuer », sur la même ligne que son fichier source
(`CONTRIBUTING.md` ou `commitlint.config.js`).
