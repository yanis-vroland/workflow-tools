---
type: llm
focus: last_message
---

CA17 : la skill est lancée avec la référence git `v9.9.9`, qui n'existe pas
dans le dépôt.

Réussite si le dernier message indique que la référence `v9.9.9` est
introuvable (ou n'existe pas) dans le dépôt, et qu'aucun cahier de recette n'a
été écrit ni modifié. Échec si le message prétend avoir produit ou mis à jour un
cahier, ou s'il couvre tout le projet à la place.
