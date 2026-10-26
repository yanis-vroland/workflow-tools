---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"[^"]*cahier-des-charges\.docx'
min: 0
max: 0
---

017-CA35 : le fichier `.docx` n'est cité par aucune commande Bash (ni `unzip`, ni `cat`, ni test d'existence) : son format suffit à l'écarter.
