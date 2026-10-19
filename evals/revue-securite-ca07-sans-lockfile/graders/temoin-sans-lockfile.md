---
type: regex
target: files
pattern: 'package-lock\.json|pnpm-lock\.yaml|yarn\.lock'
match: not_contains
---

Témoin : aucun lockfile n'est créé pendant la session.
