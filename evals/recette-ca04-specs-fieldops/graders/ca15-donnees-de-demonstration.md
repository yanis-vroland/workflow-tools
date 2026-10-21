---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n##? [^\n]*Pr[ée]requis(?:(?!\n##? )[\s\S])*src/db/seed\.ts'
match: contains
---

CA15 : « Prérequis » cite le fichier de données de démonstration src/db/seed.ts.
