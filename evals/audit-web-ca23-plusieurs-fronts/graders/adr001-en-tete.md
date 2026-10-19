---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?=(?:[^\n]*\n){0,12}[^\n]*wf-audit-web)(?=(?:[^\n]*\n){0,12}[^\n]*\b0a79cbd)(?=(?:[^\n]*\n){0,12}[^\n]*\d{4}-\d{2}-\d{2})'
match: contains
---

ADR-001 : l'en-tête (12 premières lignes) donne l'outil, la date et le commit analysé (0a79cbd, HEAD déterministe du scaffold).
