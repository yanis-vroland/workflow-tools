---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Constats dans le code[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+'
match: contains
---

Témoin de `ca09-champs-des-constats` (absence d'entrée non conforme) : au moins une entrée existe.
