---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Glossaire m[ée]tier[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*\bTariff\b)(?=[^\n]*src/models\.ts)'
match: contains
---

CA11 : le terme Tariff, défini par un commentaire, est listé avec son fichier `src/models.ts`.
