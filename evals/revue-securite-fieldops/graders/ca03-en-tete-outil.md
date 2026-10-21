---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?:(?!\n## )[\s\S])*?wf-revue-securite'
match: contains
---

CA3 (ADR-001) : l'en-tête nomme l'outil.
