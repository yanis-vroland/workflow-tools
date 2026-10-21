---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: '^(?:(?!\n#{2,3} +Objet)[\s\S])*?Date de la réunion\s*:\s*2026-10-07\b'
match: contains
---

007-CA6 : l'en-tête donne la date de la réunion au format AAAA-MM-JJ, convertie depuis « 07/10/2026 ».
