---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?:(?!\n## )[\s\S])*?Date : 2026-10-01\b'
match: not_contains
---

CA20 (ADR-001) : la date de l'en-tête n'est plus celle du livrable précédent (2026-10-01).
