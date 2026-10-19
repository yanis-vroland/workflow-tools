---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*wf-montee-version)(?=(?:[^\n]*\n){0,8}[^\n]*\b5b26289)(?=(?:[^\n]*\n){0,8}[^\n]*react-dom 19\b)'
match: contains
---

CA24 et ADR-001 : l'en-tête (8 premières lignes) cite l'outil, le commit analysé (`5b26289`) et l'argument passé (`react-dom 19`).
