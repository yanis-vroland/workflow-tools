---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*[Cc]artographie)(?=[^\n]*titulaire du compte\s*:\s*direction technique du client)'
match: contains
---

CA15 : le titulaire du compte de cartographie saisi à la main (« direction technique du client ») est conservé.

Discriminant : le dossier déposé par le scaffold suit un format antérieur (statut en colonne du milieu, « Titulaire : », tableau des secrets à trois colonnes, interlocuteur séparé par un tiret) ; seul un dossier réécrit au format actuel satisfait ce motif.
