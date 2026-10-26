---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Vérifications[^\n]*\n(?=(?:(?!\n## )[\s\S])*?\bpnpm\b[^\n`]*\btest\b)(?=(?:(?!\n## )[\s\S])*?\bpnpm\b[^\n`]*\bbuild\b)'
match: contains
---

CA16 : « Vérifications » donne les commandes des scripts `test` et `build` des applications, avec pnpm.
