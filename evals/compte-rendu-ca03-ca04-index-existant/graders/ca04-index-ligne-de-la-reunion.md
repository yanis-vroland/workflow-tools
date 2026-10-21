---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '^(?=[^\n]*2026-10-07)(?=[^\n]*[Pp]oint hebdomadaire)[^\n]*\]\((?:\./)?2026-10-07-point-hebdomadaire\.md\)'
flags: m
match: contains
---

007-CA4 : la ligne du nouveau compte rendu porte la date, l'objet et le lien relatif.
