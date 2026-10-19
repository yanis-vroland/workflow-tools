---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?![\s\S]*Date : 2026-10-01\b)[\s\S]*?\n### S4\b(?=(?:(?!\n###? )[\s\S])*?\bDELETE\b)(?=(?:(?!\n###? )[\s\S])*?routes/interventions\.ts)'
match: contains
---

CA20 : la route DELETE sans authentification, toujours présente, garde l'identifiant S4.

Discriminant : le livrable déposé par le scaffold satisfait déjà la condition ; le correcteur exige
aussi que la date du livrable précédent (2026-10-01) ait disparu, donc que le fichier ait été réécrit.
