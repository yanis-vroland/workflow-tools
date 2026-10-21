---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?![\s\S]*Date : 2026-10-01\b)[\s\S]*?\n### S9\b(?=(?:(?!\n###? )[\s\S])*?auth_service\.dart)'
match: contains
---

CA20 : le jeton dans `shared_preferences`, toujours présent, garde l'identifiant S9.

Discriminant : le livrable déposé par le scaffold satisfait déjà la condition ; le correcteur exige
aussi que la date du livrable précédent (2026-10-01) ait disparu, donc que le fichier ait été réécrit.
