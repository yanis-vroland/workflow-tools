---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:\|[ \t]*`[^`\n]+`[ \t]*\|[ \t]*\d+[ \t]*\|[ \t]*\n){21}'
match: not_contains
---

CA12 : au plus 20 fichiers sont listés.

Remplace, avec les autres correcteurs `ca12-*`, le juge `llm` `ca12-liste-des-fichiers`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
