---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '`[^`\n]*(?:npm (?:run )?test\b|npx (?:jest|vitest|mocha))|```[^`]*(?:npm (?:run )?test\b|npx (?:jest|vitest|mocha))'
match: not_contains
---

CA5 : aucune commande de test n'est inventée (aucune commande de test présentée en code).
