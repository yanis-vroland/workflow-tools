---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*ticket/)(?=[^\n]*CONTRIBUTING\.md)'
match: contains
---

CA9 : le nommage des branches (`ticket/<numéro>-<sujet-court>`) est repris dans
« Contribuer », sur la même ligne que son fichier source, `CONTRIBUTING.md`.
