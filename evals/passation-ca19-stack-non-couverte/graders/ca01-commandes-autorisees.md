---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F|git symbolic-ref refs/remotes/origin/HEAD|git show-ref --verify refs/heads/(?:main|master)|git branch -a --no-merged=(?!-)[\w./-]+|git rev-list --count --end-of-options (?!-)[\w./-]+\.\.(?!-)[\w./-]+|git log -1 --format=%cs --end-of-options (?!-)[\w./-]+)")'
min: 0
max: 0
---

CA1 et hors périmètre : Bash ne sert qu'aux commandes en lecture que la skill
autorise, chacune seule et sans guillemets, redirection ni enchaînement :
`git rev-parse --short HEAD`, `git status --porcelain`, `date +%F`,
`git symbolic-ref refs/remotes/origin/HEAD`, `git show-ref --verify refs/heads/main`
(ou `master`), `git branch -a --no-merged=<principale>`,
`git rev-list --count --end-of-options <principale>..<branche>`,
`git log -1 --format=%cs --end-of-options <branche>` ; aucun argument ne commence par `-`.
Toute autre commande échoue : modification du dépôt ou des fichiers, exécution du
projet, et récupération distante (`git fetch`, `git pull`, `git ls-remote`, hors
périmètre de la spec 016).
