---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '- Date : 2026-10-14\n[\s\S]*- Derniers identifiants attribués : B07, Q06\n[\s\S]*- Q06 \(B07\) : [^\n]*\n  Réponse :\n\n## Points non déterminés'
match: contains
---

005-CA1 : le livrable de cadrage n'est pas modifié (date, dernière ligne d'en-tête et dernière question, au champ « Réponse : » vide, intactes).
