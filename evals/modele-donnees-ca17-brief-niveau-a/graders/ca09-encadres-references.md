---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^> *\**(D\d\d)\b(?![\s\S]*\bvoir `?\1\b)(?<!\bvoir `?\1\b[\s\S]*)'
flags: m
match: not_contains
---

017-CA9 (« l'outil n'en recommande aucune ») : le modèle ne tient pour acquise aucune option d'un encadré non décidé. Chaque encadré `Dnn` est donc renvoyé, hors de l'encadré, par « voir `Dnn` » sur au moins un élément du modèle qui en dépend (attribut, relation, règle) ; un encadré que rien ne référence signifie que le modèle a retenu une option en silence.
