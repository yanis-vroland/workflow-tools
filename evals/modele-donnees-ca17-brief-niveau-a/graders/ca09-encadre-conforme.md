---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?À décider *$(?:(?!^## )[\s\S])*?^> *\**D01\b[^\n]*\n(?:>[^\n]*\n)*?> *\**Contexte\** *:[^\n]*(«|supposé)[^\n]*\n(?:>[^\n]*\n)*?> *- *\**Option 1\b[^\n]*Conséquence[^\n]*\n(?:>[^\n]*\n)*?> *- *\**Option 2\b[^\n]*Conséquence[^\n]*\n(?:>[^\n]*\n)*?> *\**Décision\** *:\**[ \t]*$'
flags: m
match: contains
---

017-CA9 (amendement 2 de l'ADR-001) : « À décider » contient un encadré `D01` avec un contexte sourcé (citation ou « supposé »), au moins deux options chacune avec sa conséquence, et un champ « Décision : » vide.
