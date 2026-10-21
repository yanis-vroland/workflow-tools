---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA14 : « Synthèse de la campagne » donne le nombre de cas par statut et le
nombre total, et ces nombres correspondent exactement au tableau.

Compte toi-même les lignes du tableau de « Cas de recette » (hors en-tête et
séparation), puis le nombre de lignes par valeur de la colonne Statut (à tester,
conforme, non conforme, bloqué).

Réussite si la synthèse donne, pour chacun des quatre statuts admis, un nombre
(zéro compris, ou statut absent signifiant zéro s'il est dit explicitement), et
un total, et si chaque nombre est exactement égal à ton décompte. Échec à la
moindre différence, ou si un statut présent dans le tableau n'a pas de nombre.
