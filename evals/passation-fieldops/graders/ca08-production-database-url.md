---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bPRODUCTION_DATABASE_URL\b)(?=[^\n]*purge\.yml)'
match: contains
---

CA8 : le secret de CI `PRODUCTION_DATABASE_URL` figure dans le tableau avec le fichier qui le référence (`.github/workflows/purge.yml`).
