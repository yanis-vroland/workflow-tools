---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?###? [^\n]*Cas hors campagne(?:(?!\n##? |\n### )[\s\S])*REC-001[^\n]*002-ordres-de-travail\.md#CA1\b[^\n]*conforme[^\n]*OK recette du 12/09'
match: contains
---

CA9 : REC-001 (spec 002, inchangée depuis v1.3.0) est listé sous « Cas hors campagne » avec son statut « conforme » et son commentaire, mot pour mot.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
