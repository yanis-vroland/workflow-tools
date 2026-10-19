---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Checklist de passation[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*cartographie)(?=[^\n]*\|\s*fait\s*\|[ \t]*(?:\n|$))'
flags: "i"
match: contains
---

CA15 : le statut « fait » saisi pour le transfert de l'accès au service de cartographie est conservé.

Discriminant : le dossier déposé par le scaffold suit un format antérieur (statut en colonne du milieu, « Titulaire : », tableau des secrets à trois colonnes, interlocuteur séparé par un tiret) ; seul un dossier réécrit au format actuel satisfait ce motif.
