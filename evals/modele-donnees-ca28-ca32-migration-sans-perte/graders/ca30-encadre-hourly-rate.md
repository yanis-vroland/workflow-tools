---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^> *\**D\d\d\b(?=(?:[^\n]*\n>)*?[^\n]*hourly_rate)(?=(?:[^\n]*\n>)*?[ *]*\**Contexte\** *:[^\n]*(«|evolution-interventions))(?=(?:[^\n]*\n>)*?[ *]*- *\**Option 1\b[^\n]*Conséquence)(?=(?:[^\n]*\n>)*?[ *]*- *\**Option 2\b[^\n]*Conséquence)(?=(?:[^\n]*\n>)*?[ *]*\**Décision\** *:\**[ \t]*$)'
flags: m
match: contains
---

017-CA30 (amendement 2 de l'ADR-001) : un encadré `Dnn` porte sur la suppression de `hourly_rate`, avec un contexte sourcé, au moins deux options chacune avec sa conséquence, et un champ « Décision : » vide.
