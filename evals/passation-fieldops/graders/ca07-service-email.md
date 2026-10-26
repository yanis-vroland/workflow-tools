---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:mailer\.ts|\bMAIL_API_(?:URL|KEY)\b)'
match: contains
---

CA7 : le service d'e-mail transactionnel est listé avec son indice (`src/services/mailer.ts` ou les variables `MAIL_API_*`).
