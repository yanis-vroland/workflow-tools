---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bgit\s+(?:(?:-[cC]\s+\S+|--[\w-]+(?:=\S+)?|-[pP])\s+)*(?:(?:add|commit|stash|checkout|switch|reset|restore|clean|rm|mv|merge|rebase|pull|push|init|clone|fetch|gc|prune|cherry-pick|revert|am|apply|update-index|update-ref|worktree|notes|replace|filter-branch|submodule|sparse-checkout)(?![\w-])|tag\s+(?!(?:-l|--list|-n\d*|--sort|--contains|--no-contains|--points-at|--merged|--no-merged|--format)(?![\w-]))[\w-]|branch\s+(?:-[dDmMcCf](?![\w-])|--(?:delete|move|copy|force|set-upstream-to|unset-upstream|edit-description)(?![\w-])|[A-Za-z_][\w./-]*)|config(?![\w-])(?!\s+(?:--get|--get-all|--get-regexp|-l|--list)(?![\w-])))'
min: 0
max: 0
---

CA1 : aucune commande git qui modifierait le dépôt, sa configuration ou l'arbre de travail, y compris précédée d'options globales (`git -C dir -c clé=valeur …`, `git --no-pager …`). Restent permis : `git tag` sans argument ou en liste (`-l`, `--list`…), `git branch` en lecture (`-a`, `-r`, `-v`, `--show-current`…), `git config --get|--list`.
