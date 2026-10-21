---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '\]\((?:\./)?2026-10-14-revue-de-sprint\.md\)[\s\S]*\]\((?:\./)?2026-10-07-point-hebdomadaire\.md\)[\s\S]*\]\((?:\./)?2026-09-30-atelier-parcours-technicien\.md\)'
match: contains
---

007-CA4 : l'index liste les trois comptes rendus du dossier, avec un lien relatif vers chacun, du plus récent au plus ancien (2026-10-14, 2026-10-07, 2026-09-30).
