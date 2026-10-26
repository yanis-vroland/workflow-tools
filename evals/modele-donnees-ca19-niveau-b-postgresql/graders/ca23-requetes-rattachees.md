---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/requetes.sql" }
pattern: '^--[ \t]*R\d\d\b(?![^\n]*source)'
flags: mi
match: not_contains
---

017-CA23 : chaque commentaire de requête `Rnn` rattache la requête à un besoin et à sa source.
