---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?(?:\n#{3,6} |\n[ \t]*\d+[.)][ \t]|npm install|flutter pub)'
match: not_contains
---

CA18 : « Plan de montée » ne contient aucune étape (ni titre d'étape, ni liste numérotée, ni commande de montée).
