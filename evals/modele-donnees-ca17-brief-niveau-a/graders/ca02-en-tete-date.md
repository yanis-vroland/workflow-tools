---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?!^## )[\s\S])*?^[-*] *\**Date\** *: *\**\d{4}-\d{2}-\d{2}\b'
flags: m
match: contains
---

017-CA2 (ADR-001) : l'en-tête porte une date au format AAAA-MM-JJ.
