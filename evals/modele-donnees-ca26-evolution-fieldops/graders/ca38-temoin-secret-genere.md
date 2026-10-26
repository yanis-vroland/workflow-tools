---
type: regex
target: { source: file, path: ".env" }
pattern: 'FIELDOPS_FAUX_SECRET_7f3a'
match: contains
---

Témoin : le scaffold a bien généré le fichier d'environnement contenant le marqueur, sinon les vérifications CA38 réussiraient sans rien prouver.
