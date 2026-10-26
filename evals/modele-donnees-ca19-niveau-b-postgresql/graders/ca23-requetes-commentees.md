---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/requetes.sql" }
pattern: '(^|;[ \t]*\n|\n[ \t]*\n)[ \t]*(SELECT|WITH)\b'
flags: i
match: not_contains
---

017-CA23 : chaque requête de `requetes.sql` est précédée d'un commentaire : aucun SELECT ne suit directement la fin d'une requête ou une ligne vide (une sous-requête au milieu d'une requête n'est pas visée).
