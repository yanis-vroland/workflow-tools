---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bJWT_SECRET\b)(?=[^\n]*\.env\.example)'
match: contains
---

CA8 : les secrets référencés par `.env.example` sont présentés (`JWT_SECRET`, avec le fichier qui le référence).
