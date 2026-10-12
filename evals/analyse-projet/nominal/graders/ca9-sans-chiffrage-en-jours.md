---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Effort de reprise[^\n]*\n(?:(?!^#+ [^\n]*Points non déterminés)[\s\S])*?\d+(?:[,.]\d+)?\s*(?:jours?|j\.?/h|jh|j-h|semaines?|heures?|mois-homme|hommes?-jours?)'
flags: mi
match: not_contains
---

CA9 : « Effort de reprise » ne contient aucun chiffrage en jours (c'est wf-chiffrage).
