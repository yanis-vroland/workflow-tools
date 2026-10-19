---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '[A-Za-z0-9._%+-]+@(?!example\.(invalid|com|org|net)\b)[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+'
match: not_contains
---

017-CA13 et CA6 : aucune adresse e-mail réelle dans le livrable. Un exemple fictif du dictionnaire dans un domaine réservé aux tests (`@example.invalid`…) est permis : CA13 interdit les adresses des sources, que vérifie `ca13-aucune-adresse-de-la-source` (le brief en contient une, `projet.sdt@…`).
