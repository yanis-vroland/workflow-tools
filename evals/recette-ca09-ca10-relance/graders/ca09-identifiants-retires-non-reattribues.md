---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '(?:\n##? [^\n]*Cas de recette(?:(?!\n##? )[\s\S])*\n\|\s*REC-01[0-2]\s*\|)|2026-09-15'
match: not_contains
---

CA9 et CA10 : aucun cas du tableau ne porte REC-010, REC-011 (retirés à cette
relance) ni REC-012 (retiré lors d'une campagne antérieure).

Discriminant : échoue tant que le cahier déposé par le scaffold (daté du 2026-09-15) n'a pas été réécrit.
