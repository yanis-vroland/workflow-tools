---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bDEPLOY_TOKEN\b)(?=[^\n]*\|\s*à faire\s*\|)'
match: contains
---

CA14 : une ligne de la checklist porte sur la transmission de `DEPLOY_TOKEN`, au statut « à faire ».

Remplace, avec les autres correcteurs `ca14-*`, le juge `llm` `ca14-une-ligne-par-element`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
