---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*(?:STRIPE_SECRET_KEY|\.env\.example))'
match: contains
---

CA19 et CA7 : Stripe est listé par l'indice hors dépendances qui l'établit (variable `STRIPE_SECRET_KEY` de `.env.example`).
