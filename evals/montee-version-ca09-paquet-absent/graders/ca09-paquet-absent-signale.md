---
type: regex
target: last_message
pattern: '^(?=[\s\S]*lodash)(?=[\s\S]*(?:absent|n.est pas (?:une )?(?:dépendance|déclaré|utilisé|présent)|n.est déclaré|ne fait pas partie|ne figure (?:pas|dans aucun)|pas (?:dans|une dépendance)|introuvable dans|aucun(?:e)? (?:dépendance|manifeste)[^\n]*lodash))'
flags: i
match: contains
---

CA9 : le dernier message indique que `lodash` n'est pas une dépendance du projet.
