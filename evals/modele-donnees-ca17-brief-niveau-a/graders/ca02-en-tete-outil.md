---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?!^## )[\s\S])*?^[-*] *\**Outil\** *: *\**`?wf-modele-donnees\b'
flags: m
match: contains
---

017-CA2 (en-tête conforme à l'ADR-001) : l'en-tête nomme l'outil, `wf-modele-donnees`.
