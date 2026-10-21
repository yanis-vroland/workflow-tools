---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+|\|\s*S\d+\s*\|'
match: not_contains
---

CA19 : aucune entrée `Sn` n'est inventée sur un projet sans faille plantée.
