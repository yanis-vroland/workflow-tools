---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*feat/export-pdf)(?=[^\n]*2026-09-30)(?=[^\n]*\b3\b)'
match: contains
---

CA10 : la branche locale `feat/export-pdf` est listée avec la date de son dernier commit (2026-09-30) et ses 3 commits d'avance.
