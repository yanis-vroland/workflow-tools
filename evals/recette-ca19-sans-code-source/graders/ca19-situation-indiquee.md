---
type: llm
focus: last_message
---

CA19 : l'outil est lancé dans un répertoire qui ne contient que des documents
(brief client, notes de réunion), sans code source ni spec `docs/specs/` ni
livrable `docs/wf/specs-tickets.md`.

Réussite si le dernier message indique qu'aucun code source ni aucune spec n'a
été trouvé et qu'aucun cahier de recette n'a été écrit. Échec si le message
prétend avoir produit un cahier, ou s'il tire des cas de recette du brief ou
des notes.
