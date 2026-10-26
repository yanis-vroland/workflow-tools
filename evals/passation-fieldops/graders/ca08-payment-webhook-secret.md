---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|(?=[^\n]*\bPAYMENT_WEBHOOK_SECRET\b)(?=[^\n]*\.env\.example)'
match: contains
---

CA8 : une ligne du tableau donne `PAYMENT_WEBHOOK_SECRET`, référencé dans `.env.example`.
