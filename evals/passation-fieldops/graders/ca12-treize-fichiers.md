---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?\|[ \t]*Fichier[ \t]*\|[^\n]*\n\|[-| :]+\|[ \t]*\n(?:\|[ \t]*`[^`\n]+`[ \t]*\|[ \t]*\d+[ \t]*\|[ \t]*\n){13}(?!\|[ \t]*`[^`\n]+`[ \t]*\|[ \t]*)'
match: contains
---

CA12 : les 13 fichiers qui contiennent des marqueurs sont listés, chacun avec son nombre.

Remplace, avec les autres correcteurs `ca12-*`, le juge `llm` `ca12-liste-des-fichiers`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
