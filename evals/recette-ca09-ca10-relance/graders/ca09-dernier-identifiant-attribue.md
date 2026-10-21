---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '^(?:(?!\n##? [^\n]*P[ée]rim[èe]tre et sources)[\s\S])*?Dernier identifiant attribu[ée]\s*:\s*REC-(?:01[3-9]|0[2-9]\d|[1-9]\d\d)\b'
match: contains
---

CA9 : la ligne « Dernier identifiant attribué » de l'en-tête vaut au moins
REC-013 (REC-012 était déjà attribué, et la relance ajoute des cas). Le cahier
déposé porte REC-012 : ce correcteur échoue tant qu'il n'a pas été réécrit.
