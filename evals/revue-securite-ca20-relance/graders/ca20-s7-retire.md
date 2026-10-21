---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+(?:(?!\n###? )[\s\S])*?reports\.ts'
match: not_contains
---

CA20 : le constat S7, dont la cause a disparu (`src/api/routes/reports.ts` n'existe pas), est
retiré : plus aucune entrée ne porte sur ce fichier.
