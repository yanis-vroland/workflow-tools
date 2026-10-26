---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?docker build -t <[^>\n]+>/fieldops'
match: contains
---

CA5 : la commande exacte de construction de l'image est reprise, adresse du registre remplacée par un paramètre.

Remplace, avec les autres correcteurs `ca05-*`, le juge `llm` `ca05-environnements-et-declencheurs`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
