---
type: regex
target: files
pattern: '^(?!(.*/)?docs/wf/modele-donnees/).+$'
flags: m
match: not_contains
---

017-CA1 : aucun fichier n'est créé ni modifié hors de `docs/wf/modele-donnees/`, ni dans le code, ni dans `src/db/schema.sql`, ni dans `mobile/lib/db/local_db.dart`.
