---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?![^\n]*à créer)[^\n]*pdfExport\.ts'
flags: m
match: not_contains
---

006-CA14 : `src/domain/pdfExport.ts` n'existe que sur la branche non fusionnée `feat/export-pdf` ; s'il est cité, c'est sur une ligne qui le marque « à créer ».
