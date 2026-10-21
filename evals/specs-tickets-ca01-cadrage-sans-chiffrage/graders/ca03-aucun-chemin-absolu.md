---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '(/Users/|/home/|/tmp/|/private/|/var/|/root/|[A-Za-z]:\\)'
match: not_contains
---

006-CA3 (amendement 1) : aucun chemin absolu de la machine n'apparaît dans le livrable.
