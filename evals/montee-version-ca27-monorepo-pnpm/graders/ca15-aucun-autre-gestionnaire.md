---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '(?<![\w-])npm install\b|\byarn add\b'
match: not_contains
---

CA15 : aucune commande d'un gestionnaire non détecté (`npm install`, `yarn add`).
