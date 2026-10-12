---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Installer le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\bPAYMENT_WEBHOOK_SECRET\b'
match: contains
---

CA6 : l'étape de configuration de « Installer le projet » liste la variable PAYMENT_WEBHOOK_SECRET (dernière de `.env.example`).
