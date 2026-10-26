---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|[^\n]*\bMAP_API_KEY_EXPIRES_AT\b'
match: not_contains
---

CA8 : `MAP_API_KEY_EXPIRES_AT` (`.env.example`) est la date d'expiration d'une clé, pas un secret : il n'a pas de ligne dans le tableau des secrets.
