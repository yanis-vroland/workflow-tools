---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?\b\d{4}-\d{2}-\d{2}\b'
match: contains
---

006-CA3 (ADR-001) : l'en-tête, avant la première section, porte une date au format AAAA-MM-JJ.
