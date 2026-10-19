---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?Évolution *$(?:(?!^## )[\s\S])*?(src/db/schema\.sql[\s\S]*mobile/lib/db/local_db\.dart|mobile/lib/db/local_db\.dart[\s\S]*src/db/schema\.sql)'
flags: m
match: contains
---

017-CA26 : « Évolution » cite les deux schémas détectés par leur chemin, `src/db/schema.sql` et `mobile/lib/db/local_db.dart`.
