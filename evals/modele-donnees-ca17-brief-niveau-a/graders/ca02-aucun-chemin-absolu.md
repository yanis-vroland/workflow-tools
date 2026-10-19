---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '(/Users/|/home/|/tmp/|/private/|/var/|/root/|[A-Za-z]:\\)'
match: not_contains
---

017-CA2 : aucun chemin absolu de la machine n'apparaît dans le livrable.
