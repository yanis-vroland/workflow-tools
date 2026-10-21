---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\bchangeme\b|\b(?:admin|dispatch|tech1|tech2)@|2027-03-31'
flags: i
match: not_contains
---

CA15 : aucun identifiant de connexion, mot de passe ni valeur de variable
d'environnement : ni la valeur factice `changeme` de `.env.example` (mot
entier : « changements » est permis), ni les comptes de démonstration de
`src/db/seed.ts`, ni la valeur de `MAP_API_KEY_EXPIRES_AT`.
