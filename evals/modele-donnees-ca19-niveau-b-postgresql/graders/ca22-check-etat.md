---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/schema.sql" }
pattern: 'CHECK\s*\(\s*"?\w*(status|state)\w*"?\s+IN\s*\('
flags: i
match: contains
---

017-CA22 : l'ensemble fini des états d'une intervention (règle RG07) est imposé par une contrainte `CHECK … IN (…)`.
