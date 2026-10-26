---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*\b[Rr]ecette\b)[^\n]*`main`'
match: contains
---

CA5 : l'environnement de recette est donné avec son déclencheur exact, le push sur la branche `main`, sur la même ligne.

Remplace, avec les autres correcteurs `ca05-*`, le juge `llm` `ca05-environnements-et-declencheurs`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
