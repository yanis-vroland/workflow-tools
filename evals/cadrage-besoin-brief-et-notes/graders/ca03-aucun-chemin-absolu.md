---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(/Users/|/home/|/tmp/|/private/|/var/|/root/|[A-Za-z]:\\)'
match: not_contains
---

004-CA3 (amendement 1) : les sources sont désignées par leur nom de fichier seul ; aucun chemin absolu de la machine n'apparaît dans le livrable.
