---
type: regex
target: files
pattern: '^docs/'
flags: "m"
match: not_contains
---

CA19 : documents sans code source ni spec : aucun fichier n'est créé sous docs/.
