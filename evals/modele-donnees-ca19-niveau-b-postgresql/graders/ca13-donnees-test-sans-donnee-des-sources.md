---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/donnees-test.sql" }
pattern: 'Sophie|Renaud|Marc Olivier|projet\.sdt|Démo Thermique'
match: not_contains
---

017-CA13 et CA24 : aucun nom de personne, aucune adresse e-mail ni aucun nom de société tiré des sources n'apparaît dans les données de test.
