---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '`[^`\n]*(?:npm (?:install|ci|i)\b|pnpm (?:install|i)\b|yarn(?: install)?\b)|```[^`]*(?:npm (?:install|ci|i)\b|pnpm (?:install|i)\b|yarn(?: install)?\b)'
match: not_contains
---

CA4 : aucun fichier du projet ne donne de commande d'installation des
dépendances ; aucune n'est présentée en code, même déduite de `package.json`.
