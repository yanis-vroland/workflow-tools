---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^(?:(?!\n#{1,2} )[\s\S])*?\bwf-specs-tickets\b'
match: contains
---

006-CA3 (ADR-001) : l'en-tête, avant la première section, nomme l'outil `wf-specs-tickets`.
