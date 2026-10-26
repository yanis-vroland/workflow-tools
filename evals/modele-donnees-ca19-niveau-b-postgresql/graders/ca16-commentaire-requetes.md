---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/requetes.sql" }
pattern: '^\s*--[^\n]*wf-modele-donnees[^\n]*index\.md'
match: contains
---

017-CA16 : `requetes.sql` commence par un commentaire qui nomme l'outil et renvoie à `index.md`.
