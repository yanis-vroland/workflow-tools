---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b'
match: not_contains
---

ADR-001 : le livrable ne contient aucune adresse e-mail (contributeurs fictifs `@example.invalid` de l'historique compris).
