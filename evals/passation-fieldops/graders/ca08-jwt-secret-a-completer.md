---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|[^\n]*\bJWT_SECRET\b[^\n]*\|[ \t]*à compléter[ \t]*\|[ \t]*(?=\n|$)'
match: contains
---

CA8 : « Comment l'obtenir » vaut « à compléter » pour `JWT_SECRET`, qu'aucun service ne délivre.

Remplace, avec les autres correcteurs `ca08-*`, le juge `llm` `ca08-colonnes-etablies`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
