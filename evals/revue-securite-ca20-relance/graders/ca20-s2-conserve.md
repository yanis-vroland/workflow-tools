---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?![\s\S]*Date : 2026-10-01\b)[\s\S]*?\n### S2\b(?=(?:(?!\n###? )[\s\S])*?routes/interventions\.ts)(?=(?:(?!\n###? )[\s\S])*?injection)'
flags: 'i'
match: contains
---

CA20 : l'injection SQL de `src/api/routes/interventions.ts`, toujours présente, garde l'identifiant S2.

Discriminant : le livrable déposé par le scaffold satisfait déjà la condition ; le correcteur exige
aussi que la date du livrable précédent (2026-10-01) ait disparu, donc que le fichier ait été réécrit.
