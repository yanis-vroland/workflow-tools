---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bSTRIPE_SECRET_KEY\b)(?=[^\n]*\.env\.example)'
match: contains
---

CA8 : `STRIPE_SECRET_KEY` figure dans le tableau des secrets, référencé dans `.env.example`.
