---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '^(?=[^\n]*2026-10-07)(?=[^\n]*[Pp]oint hebdo)[^\n]*\]\((?:\./)?2026-10-07-point-hebdo-fieldops\.md\)'
flags: m
match: contains
---

007-CA4 : l'index liste le compte rendu sur une ligne qui porte la date de la réunion, son objet et un lien relatif vers le fichier.
