---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\.)+[A-Za-z]{2,}\b'
match: not_contains
---

CA17 : le livrable ne contient aucune adresse e-mail (auteurs fictifs `@example.invalid` de l'historique, données de démonstration et `.env.example` compris).
