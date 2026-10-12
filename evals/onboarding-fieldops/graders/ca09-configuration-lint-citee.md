---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Contribuer[^\n]*\n(?:(?!\n##? )[\s\S])*?\.eslintrc\.json'
match: contains
---

CA9 : « Contribuer » cite la configuration de lint `.eslintrc.json`.
