---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*d[ée]p[ôo]t)(?=[^\n]*\|\s*en cours\s*\|[ \t]*(?:\n|$))'
match: contains
---

CA15 : le statut « en cours » saisi pour le dépôt de code est conservé.

Discriminant : le dossier déposé par le scaffold suit un format antérieur (statut en colonne du milieu, « Titulaire : », tableau des secrets à trois colonnes, interlocuteur séparé par un tiret) ; seul un dossier réécrit au format actuel satisfait ce motif.
