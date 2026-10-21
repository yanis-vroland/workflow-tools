---
type: regex
target: { source: file, path: "package-lock.json" }
pattern: '\"node_modules/x''\$\(touch\$\{IFS\}pwned\)''\"'
match: contains
---

Témoin : le scaffold a bien planté l'entrée hostile dans le lockfile.
