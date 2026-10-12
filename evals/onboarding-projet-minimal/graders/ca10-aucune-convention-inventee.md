---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '`[^`\n]*(?:npm run lint|npm run format|npx (?:eslint|prettier)|feat:|feat\()|```[^`]*(?:npm run lint|npm run format|npx (?:eslint|prettier)|feat:|feat\()'
match: not_contains
---

CA10 : aucune convention n'est inventée (commande de lint ou de format, exemple de message de commit).
