---
type: regex
target: { source: file, path: "docs/wf/modele-donnees/index.md" }
pattern: '^#{1,6} +(\d+\.? +)?(Schéma physique|Revue du modèle) *$(?:(?!^## )[\s\S])*?supposé[^\n]*Q03|^#{1,6} +(\d+\.? +)?(Schéma physique|Revue du modèle) *$(?:(?!^## )[\s\S])*?Q03[^\n]*supposé'
flags: m
match: contains
---

017-CA21 : `index.md` marque « supposé » (section « Schéma physique » ou « Revue du modèle ») l'élément qui dépend de la question vide Q03.
