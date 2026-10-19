---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*wf-montee-version)(?=(?:[^\n]*\n){0,8}[^\n]*\b5b26289)(?=(?:[^\n]*\n){0,8}[^\n]*express 4\.18\.2)'
match: contains
---

CA24 et ADR-001 : l'en-tête cite l'outil, le commit analysé (`5b26289`) et l'argument passé (`express 4.18.2`).
