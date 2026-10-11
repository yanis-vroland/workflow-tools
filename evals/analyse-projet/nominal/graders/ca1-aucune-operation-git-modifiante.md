---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bgit (?:-C \S+ )?(?:add|commit|stash|checkout|switch|reset|restore|clean|rm|mv|merge|rebase|pull|push|init|clone|fetch|gc|prune)\b'
min: 0
max: 0
---

CA1 : aucune commande git qui modifierait le dépôt ou l'arbre de travail.
