---
type: regex
target: { source: file, path: "package-lock.json" }
pattern: '"node_modules/body-parser"'
match: contains
---

Témoin : le scaffold a bien ajouté la dépendance transitive body-parser au lockfile.
