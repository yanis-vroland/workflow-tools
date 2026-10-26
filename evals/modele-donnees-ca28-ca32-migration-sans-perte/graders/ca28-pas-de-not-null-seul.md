---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: 'ADD\s+COLUMN\s+(IF\s+NOT\s+EXISTS\s+)?"?\w*priorit\w*"?(?![^,;\n]*DEFAULT)[^,;\n]*NOT\s+NULL'
flags: i
match: not_contains
---

017-CA28 : la colonne obligatoire de priorité n'est jamais ajoutée à la table existante avec `NOT NULL` sans valeur par défaut.
