---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?(?:^(?=(?:[^\n]*\n){0,12}[^\n]*wf-audit-web)(?=(?:[^\n]*\n){0,12}[^\n]*\b475123a)(?=(?:[^\n]*\n){0,12}[^\n]*\d{4}-\d{2}-\d{2}))'
match: contains
---

ADR-001 : l'en-tête (12 premières lignes) donne l'outil, la date et le commit analysé (475123a, HEAD déterministe du scaffold).
