---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues(?:(?!\n## Points non déterminés)[\s\S])*?(?:laravel|\bphp\s+\^?\d|composer\s+(?:require|update|install))'
flags: i
match: not_contains
---

CA22 : aucune cible, rupture, étape ni vérification ne porte sur la partie PHP (`laravel/framework`, version de PHP, commandes composer).
