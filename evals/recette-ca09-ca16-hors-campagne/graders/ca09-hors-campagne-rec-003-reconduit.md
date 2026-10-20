---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?###? [^\n]*Cas hors campagne(?:(?!\n##? |\n### )[\s\S])*REC-003[^\n]*002-ordres-de-travail\.md#CA3\b[^\n]*bloqu[ée][^\n]*Aucun ordre de test sous 500 €'
match: contains
---

CA9 : REC-003 est listé sous « Cas hors campagne » avec son statut « bloqué » et son commentaire, mot pour mot.

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
