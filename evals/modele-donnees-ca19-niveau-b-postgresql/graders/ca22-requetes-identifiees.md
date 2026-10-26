---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/requetes.sql" }
pattern: '^--[ \t]*R01\b[^\n]*:'
flags: m
match: contains
---

017-CA22 et CA23 : les requêtes de `requetes.sql` sont identifiées (`-- R01 : …`), ce qui permet aux justifications d'index de les citer.
