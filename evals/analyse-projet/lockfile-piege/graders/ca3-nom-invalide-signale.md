---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +Points non déterminés[^\n]*\n(?:(?!## )[^\n]*\n)*?[^\n]*nom de paquet invalide, non vérifié'
flags: m
match: contains
---

Amendement de CA3 : « Points non déterminés » signale le nom de paquet piégé avec la mention fixe « nom de paquet invalide, non vérifié ».
