---
type: regex
target: files
pattern: '^docs/'
flags: "m"
match: not_contains
---

CA20 : il n'y a qu'une application Flutter, sans front web JS/TS, aucun fichier n'est créé sous docs/.
