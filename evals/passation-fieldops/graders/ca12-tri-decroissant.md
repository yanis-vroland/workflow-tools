---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?\|[ \t]*`[^`\n]+`[ \t]*\|[ \t]*1[ \t]*\|[ \t]*\n(?:\|[^\n]*\n)*?\|[ \t]*`[^`\n]+`[ \t]*\|[ \t]*(?:[2-9]|\d{2,})[ \t]*\|'
match: not_contains
---

CA12 : le tableau des marqueurs est trié par nombre décroissant : aucun fichier à 1 marqueur n'y précède un fichier qui en compte davantage.

Remplace, avec les autres correcteurs `ca12-*`, le juge `llm` `ca12-liste-des-fichiers`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
