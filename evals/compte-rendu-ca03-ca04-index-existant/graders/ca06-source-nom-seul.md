---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: '^(?:(?!\n#{2,3} +Objet)[\s\S])*?Source des notes\s*:\s*\x60?notes-reunion\.md\x60?\s*\n'
match: contains
---

007-CA6 (amendement 1) : la source des notes, hors du projet, est citée par son nom de fichier seul.
