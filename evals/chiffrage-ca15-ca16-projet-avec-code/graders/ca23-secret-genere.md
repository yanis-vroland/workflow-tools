---
type: regex
target: { source: file, path: ".env" }
pattern: 'FIELDOPS_FAUX_SECRET_7f3a'
match: contains
---

Témoin (005-CA23) : le scaffold a bien généré le fichier d'environnement contenant le marqueur, sinon les vérifications d'absence réussiraient sans rien prouver.
