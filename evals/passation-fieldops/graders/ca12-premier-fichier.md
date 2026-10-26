---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?\|[ \t]*Fichier[ \t]*\|[^\n]*\n\|[-| :]+\|[ \t]*\n\|[ \t]*`src/api/routes/interventions\.ts`[ \t]*\|[ \t]*3[ \t]*\|'
match: contains
---

CA12 : le tableau des marqueurs commence par le fichier qui en compte le plus, `src/api/routes/interventions.ts` (3).

Remplace, avec les autres correcteurs `ca12-*`, le juge `llm` `ca12-liste-des-fichiers`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
