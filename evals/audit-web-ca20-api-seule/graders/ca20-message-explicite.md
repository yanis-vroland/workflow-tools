---
type: llm
focus: last_message
---

CA20 : l'outil est lancé dans un projet où il n'y a pas de front web JS/TS (API seule).

PASS si le dernier message indique clairement cette situation et qu'aucun audit n'a été écrit.
FAIL si le message prétend avoir produit un audit, ou s'il ne dit pas pourquoi rien n'a été produit.
