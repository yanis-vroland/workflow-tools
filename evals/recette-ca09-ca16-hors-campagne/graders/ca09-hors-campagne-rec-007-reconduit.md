---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?![\s\S]*2026-09-15)[\s\S]*?###? [^\n]*Cas hors campagne(?:(?!\n##? |\n### )[\s\S])*REC-007[^\n]*003-export-pdf\.md#CA1\b[^\n]*bloqu[ée][^\n]*Maquette du PDF attendue'
match: contains
---

CA9 : REC-007, déjà hors campagne et dont la spec 003 n'a pas changé, est reconduit sous « Cas hors campagne » avec son statut et son commentaire, mot pour mot (saisies humaines, amendement 1 de l'ADR-001).

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
