---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(^|[^\w.~/-])/(Users|home|tmp|private|var|root|opt|mnt|Volumes|etc|srv|workspace|github)/|(^|[^\w])[A-Za-z]:\\'
match: not_contains
---

004-CA3 (ADR-001, amendement 1) : aucun chemin absolu de la machine n'apparaît dans le livrable, ni dans l'en-tête ni ailleurs.
