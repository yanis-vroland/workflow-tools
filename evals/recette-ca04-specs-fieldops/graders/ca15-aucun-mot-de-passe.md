---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: 'changeme|\b(?:admin|dispatch|tech1|tech2)@'
flags: i
match: not_contains
---

CA15 : aucun identifiant de connexion ni mot de passe : ni la valeur factice
`changeme` de `.env.example`, ni les comptes de démonstration de `src/db/seed.ts`.
