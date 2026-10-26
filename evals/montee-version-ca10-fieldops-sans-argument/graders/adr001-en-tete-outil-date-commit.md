---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '^(?=(?:[^\n]*\n){0,8}[^\n]*wf-montee-version)(?=(?:[^\n]*\n){0,8}[^\n]*\b18776c7)(?=(?:[^\n]*\n){0,8}[^\n]*\b\d{4}-\d{2}-\d{2}\b)'
match: contains
---

ADR-001 : l'en-tête (8 premières lignes) cite l'outil, la date et le commit analysé. `18776c7` est le HEAD du scaffold (FieldOps puis commit du livrable de sécurité), rejouable : une modification de la fixture ou du scaffold le change.
