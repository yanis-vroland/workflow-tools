---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F|git symbolic-ref refs/remotes/origin/HEAD|git show-ref --verify refs/heads/(?:main|master)|git branch -a --no-merged [\w./-]+|git rev-list --count [\w./-]+\.\.[\w./-]+|git log -1 --format=%cs [\w./-]+)")'
min: 0
max: 0
---

CA1 et hors périmètre : Bash ne sert qu'aux commandes en lecture que la skill
autorise, chacune seule et sans guillemets, redirection ni enchaînement :
`git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`,
`git symbolic-ref refs/remotes/origin/HEAD`, `git show-ref --verify refs/heads/main`
(ou `master`), `git branch -a --no-merged <branche>`,
`git rev-list --count <principale>..<branche>`, `git log -1 --format=%cs <branche>`.
Toute autre commande échoue : modification du dépôt ou des fichiers, exécution du
projet, et récupération distante (`git fetch`, `git pull`, `git ls-remote`, hors
périmètre de la spec 016).
