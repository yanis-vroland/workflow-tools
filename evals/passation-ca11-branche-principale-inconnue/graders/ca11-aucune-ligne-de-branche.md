---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?export-pdf'
match: not_contains
---

CA11 et CA14 : aucune branche n'étant déclarée non fusionnée, la checklist ne contient aucune ligne de branche (`feat/export-pdf`).
