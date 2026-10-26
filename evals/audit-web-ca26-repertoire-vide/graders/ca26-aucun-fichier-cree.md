---
type: regex
target: files
pattern: '^docs/'
flags: "m"
match: not_contains
---

CA26 : le répertoire est vide, aucun fichier n'est créé sous docs/.
