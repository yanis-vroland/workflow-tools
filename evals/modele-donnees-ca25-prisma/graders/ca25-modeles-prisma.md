---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.prisma" }
pattern: '^datasource\s+\w+\s*\{[\s\S]*^model\s+\w+\s*\{[\s\S]*@relation\('
flags: m
match: contains
---

017-CA25 : `schema.prisma` déclare une source de données, des modèles et des relations au format Prisma.
