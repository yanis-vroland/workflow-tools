---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '`[^`\n]*(?:npm (?:run )?start\b|npm run dev\b|node dist|node src|\btsx\b|ts-node)|```[^`]*(?:npm (?:run )?start\b|npm run dev\b|node dist|node src|\btsx\b|ts-node)'
match: not_contains
---

CA19 : aucune commande de lancement n'est inventée (aucune commande de lancement présentée en code).
