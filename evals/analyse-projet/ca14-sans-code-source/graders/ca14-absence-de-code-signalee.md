---
type: llm
focus: last_message
---

Le répertoire analysé ne contenait que des documents (brief client, notes de réunion), sans aucun code source.
PASS si la réponse indique que le répertoire ne contient pas de code source, ET qu'aucun livrable n'a été écrit.
FAIL si la réponse présente un diagnostic technique du projet, invente une stack, ou annonce avoir écrit un livrable.
