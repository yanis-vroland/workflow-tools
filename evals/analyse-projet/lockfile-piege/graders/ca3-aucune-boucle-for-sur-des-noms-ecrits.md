---
type: tool_used
tool: Bash
input_match: 'for p in '''
min: 0
max: 0
---

Amendement de CA3 : aucun nom de paquet n'est recopié entre apostrophes dans la liste d'une boucle `for` (forme antérieure de la skill, vulnérable à un nom contenant une apostrophe).
