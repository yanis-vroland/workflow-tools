---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(?<![\s\S])(?:(?!^## )[\s\S])*?^[-*] *\**Commit analysé\** *:\**[^\n]*\b[0-9a-f]{7,40}\b'
flags: m
match: not_contains
---

017-CA2 (ADR-001) : aucun hash de commit n'est inventé dans l'en-tête.
