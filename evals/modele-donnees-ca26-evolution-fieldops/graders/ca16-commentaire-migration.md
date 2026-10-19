---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/migration.sql" }
pattern: '^\s*--[^\n]*wf-modele-donnees[^\n]*index\.md'
match: contains
---

017-CA16 : `migration.sql` commence par un commentaire qui nomme l'outil et renvoie à `index.md`.
