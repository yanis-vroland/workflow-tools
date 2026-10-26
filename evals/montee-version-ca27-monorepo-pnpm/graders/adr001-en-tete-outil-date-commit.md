---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*wf-montee-version)(?=(?:[^\n]*\n){0,8}[^\n]*\b822183b)(?=(?:[^\n]*\n){0,8}[^\n]*\b\d{4}-\d{2}-\d{2}\b)'
match: contains
---

ADR-001 : l'en-tête cite l'outil, la date et le commit analysé (`822183b`, HEAD du scaffold, rejouable).
