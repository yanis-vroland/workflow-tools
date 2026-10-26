---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Travaux en cours[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*notifications-push)(?=[^\n]*2026-10-05)(?=[^\n]*\b2\b)'
match: contains
---

CA10 : la branche distante connue localement `origin/feat/notifications-push` est listée avec la date de son dernier commit (2026-10-05) et ses 2 commits d'avance.
