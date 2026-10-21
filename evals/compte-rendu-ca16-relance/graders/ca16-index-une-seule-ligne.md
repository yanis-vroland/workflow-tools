---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/index.md" }
pattern: '\]\((?:\./)?2026-10-07-point-hebdo-fieldops\.md\)[^\n]*\n[\s\S]*\]\((?:\./)?2026-10-07-point-hebdo-fieldops\.md\)'
match: not_contains
---

007-CA16 : l'index ne contient qu'une ligne (un seul lien) pour cette réunion.
