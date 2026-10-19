---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '^(?=[^\n]*2026-10-14)(?=[^\n]*[Rr]evue de sprint 3)[^\n]*\]\((?:\./)?2026-10-14-revue-de-sprint-3\.md\)'
flags: m
match: contains
---

007-CA4 : l'index est créé et liste le compte rendu (date, objet, lien relatif).
