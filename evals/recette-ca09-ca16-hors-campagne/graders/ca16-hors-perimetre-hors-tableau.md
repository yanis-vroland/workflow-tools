---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*Cas de recette(?:(?!\n##? )[\s\S])*\n\|\s*REC-\d{3}\s*\|[^\n]*(?:002-ordres-de-travail|003-export-pdf)\.md|2026-09-15'
match: not_contains
---

CA16 : les specs 002 et 003, inchangées depuis v1.3.0, ne produisent aucun cas
dans le tableau.
