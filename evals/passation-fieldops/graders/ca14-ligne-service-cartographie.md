---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*cartographie)(?=[^\n]*\|\s*à faire\s*\|)'
flags: "i"
match: contains
---

CA14 : une ligne de la checklist porte sur le transfert de l'accès au service (cartographie), au statut « à faire ».

Remplace, avec les autres correcteurs `ca14-*`, le juge `llm` `ca14-une-ligne-par-element`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
