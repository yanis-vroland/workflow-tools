---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\b(?:npm|pnpm|yarn)\s+(?:run\s+)?(?:test|build|lint)\b|\bnpx\b|\b(?:vitest|jest|phpunit)\b'
match: not_contains
---

CA17 : aucune commande de test, de lint ou de build n'est inventée.
