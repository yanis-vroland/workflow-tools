---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?![ \t]*Action\b)(?![ \t]*:?-)[^\n]*\|(?![ \t]*à faire[ \t]*\|)[^|\n]*\|[ \t]*(?=\n|$)'
match: not_contains
---

CA14 : à la création, chaque ligne de la checklist porte le statut « à faire ».

Remplace, avec les autres correcteurs `ca14-*`, le juge `llm` `ca14-une-ligne-par-element`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
