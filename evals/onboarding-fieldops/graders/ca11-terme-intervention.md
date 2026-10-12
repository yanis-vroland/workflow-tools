---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Glossaire m[ée]tier[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*\bIntervention\b)(?=[^\n]*(?:types\.ts|schema\.sql|intervention\.dart))'
match: contains
---

CA11 : le glossaire contient le terme Intervention avec le fichier où il est défini.
