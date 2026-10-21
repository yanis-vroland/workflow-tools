---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-14-revue-de-sprint-3.md" }
pattern: '^(?:(?!\n#{2,3} +Objet)[\s\S])*?Source des notes\s*:\s*notes fournies dans la conversation'
match: contains
---

007-CA2 et CA6 : l'en-tête indique « notes fournies dans la conversation » comme source des notes.
