---
type: regex
target: { source: file, path: ".env" }
pattern: 'MODELE_FAUX_SECRET_3c8d'
match: contains
---

Témoin : le scaffold a bien généré le fichier d'environnement contenant le marqueur, sinon les vérifications CA38 réussiraient sans rien prouver.
