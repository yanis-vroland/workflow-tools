---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?###? [^\n]*Cas hors campagne(?:(?!\n##? |\n### )[\s\S])*REC-002[^\n]*002-ordres-de-travail\.md#CA2\b[^\n]*non conforme[^\n]*TVA calculée sur le total TTC'
match: contains
---

CA9 : REC-002 est listé sous « Cas hors campagne » avec son statut « non conforme » et son commentaire, mot pour mot.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
