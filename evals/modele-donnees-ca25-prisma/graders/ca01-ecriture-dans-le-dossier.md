---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/modele-donnees/).+$'
flags: m
match: not_contains
---

017-CA1 : aucun fichier n'est créé ni modifié hors de `docs/wf/modele-donnees/` (ni `prisma/schema.prisma`, ni `package.json`).
