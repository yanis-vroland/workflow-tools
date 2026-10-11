---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F)")'
min: 0
max: 0
---

CA14 et hors périmètre : Bash ne sert qu'aux trois commandes que la skill autorise
(`git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`), chacune seule.
Toute autre commande échoue, y compris une exécution du projet déguisée
(`FOO=1 npm test`, `env npm …`, `bash -c "npm …"`, `(npm test)`).
