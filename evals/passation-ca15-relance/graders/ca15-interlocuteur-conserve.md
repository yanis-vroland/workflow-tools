---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se[^\n]*\n(?:(?!\n##? )[\s\S])*?côté client\s*:\s*direction technique du client'
match: contains
---

CA15 : l'interlocuteur saisi à la main dans la Synthèse (responsable côté client : direction technique du client) est conservé.

Discriminant : le dossier déposé par le scaffold suit un format antérieur (statut en colonne du milieu, « Titulaire : », tableau des secrets à trois colonnes, interlocuteur séparé par un tiret) ; seul un dossier réécrit au format actuel satisfait ce motif.
