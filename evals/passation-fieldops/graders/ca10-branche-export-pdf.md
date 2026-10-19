---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*feat/export-pdf)(?=[^\n]*2026-09-30)(?=[^\n]*\b3\b)'
match: contains
---

CA10 : la branche non fusionnée `feat/export-pdf` est listée sur une ligne avec la date de son dernier commit (2026-09-30) et ses 3 commits d'avance.
