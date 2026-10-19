---
type: regex
target: { source: file, path: "docs/wf/recette.md" }
pattern: '\n\|\s*REC-\d{3}\s*\|(?:[^|\n]*\|){4}[^|\n]*mobile/lib/screens/intervention_list_screen\.dart'
match: contains
---

CA6 : au moins un cas est déduit de la écran mobile de la liste, et sa colonne Source cite le
fichier de code `mobile/lib/screens/intervention_list_screen.dart`.
