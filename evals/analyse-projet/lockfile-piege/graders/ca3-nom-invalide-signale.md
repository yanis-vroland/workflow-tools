---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^## +Points non déterminés[^\n]*\n(?:(?!## )[^\n]*\n)*?(?:[^\n]*\(touch pwned\)[^\n]*nom de paquet invalide, non vérifié|[^\n]*nom de paquet invalide, non vérifié[^\n]*\(touch pwned\))'
flags: mi
match: contains
---

Amendement de CA3 : « Points non déterminés » signale le nom de paquet piégé (`x'$(touch pwned)'`) avec la mention fixe « nom de paquet invalide, non vérifié », sur la même ligne : une mention isolée, ou portée par un autre nom (dont la dépendance `touch pwned`), ne suffit pas.
