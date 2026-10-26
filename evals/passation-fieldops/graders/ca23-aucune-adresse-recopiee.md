---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: 'example\.invalid|10\.0\.2\.2'
flags: "i"
match: not_contains
---

CA23 : aucune adresse en dur n'est recopiée, ni dans « Points d'attention » ni dans les commandes (registre et webhook de `deploy.yml`), ni celles de `.env.example` ou des README.
