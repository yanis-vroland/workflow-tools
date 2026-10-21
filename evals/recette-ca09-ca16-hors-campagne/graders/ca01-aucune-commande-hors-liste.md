---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F|git log -1 --format=%h --end-of-options v1\.3\.0 --|git diff --name-only --end-of-options v1\.3\.0 HEAD|git show --end-of-options v1\.3\.0:docs/wf/specs-tickets\.md)")'
min: 0
max: 0
---

CA1 et hors périmètre (aucune exécution) : Bash ne sert qu'aux commandes en
lecture que la skill prescrit, chacune seule. Toute autre commande échoue :
écriture, `mkdir`, exécution du projet ou de ses tests, lecture par `cat`.
