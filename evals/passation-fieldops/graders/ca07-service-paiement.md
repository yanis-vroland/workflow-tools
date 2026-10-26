---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:payment\.ts|\bPAYMENT_API_(?:URL|KEY)\b)'
match: contains
---

CA7 : le service de paiement est listé avec son indice (`src/services/payment.ts` ou les variables `PAYMENT_API_*`).
