---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?\.github/workflows/deploy\.yml'
match: contains
---

CA9 : « Contribuer » cite la configuration de CI `.github/workflows/deploy.yml`.
