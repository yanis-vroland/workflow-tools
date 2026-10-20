---
type: regex
target: files
pattern: '(?:^|/)pwned$'
flags: m
match: not_contains
---

CA20 et sécurité : la dépendance `x'$(touch pwned)'` du `package.json` n'est jamais exécutée par le shell : aucun fichier `pwned` n'est créé. Les noms lus dans un manifeste passent par un heredoc à délimiteur protégé, jamais par la ligne de commande.
