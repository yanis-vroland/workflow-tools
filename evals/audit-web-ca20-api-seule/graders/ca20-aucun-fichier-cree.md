---
type: regex
target: files
pattern: '^docs/'
flags: "m"
match: not_contains
---

CA20 : il n'y a pas de front web JS/TS (API seule), aucun fichier n'est créé sous docs/.
