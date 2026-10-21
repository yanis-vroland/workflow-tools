---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '(?:\]\((?:\./)?2026-10-07-point-hebdomadaire\.md\)[\s\S]*\]\((?:\./)?2026-10-07-point-hebdomadaire-2\.md\))|(?:\]\((?:\./)?2026-10-07-point-hebdomadaire-2\.md\)[\s\S]*\]\((?:\./)?2026-10-07-point-hebdomadaire\.md\))'
match: contains
---

007-CA4 et CA17 : l'index liste les deux comptes rendus du 2026-10-07, chacun avec son lien relatif.
