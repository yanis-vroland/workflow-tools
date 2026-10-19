---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$'
flags: m
match: not_contains
---

017-CA3 : la section « Évolution » est propre au niveau C ; elle n'apparaît pas au niveau B.
