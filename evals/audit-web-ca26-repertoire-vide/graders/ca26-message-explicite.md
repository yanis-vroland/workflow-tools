---
type: llm
focus: last_message
---

CA26 : l'outil est lancé dans un projet où le répertoire est vide.

PASS si le dernier message indique clairement cette situation et qu'aucun audit n'a été écrit.
FAIL si le message prétend avoir produit un audit, ou s'il ne dit pas pourquoi rien n'a été produit.
