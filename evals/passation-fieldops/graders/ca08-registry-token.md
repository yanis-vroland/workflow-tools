---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bREGISTRY_TOKEN\b)(?=[^\n]*deploy\.yml)'
match: contains
---

CA8 : une ligne du tableau donne `REGISTRY_TOKEN` avec le fichier qui le référence (`.github/workflows/deploy.yml`).
