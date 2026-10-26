---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Plan de montée[^\n]*\n(?:(?!\n## )[\s\S])*?\bpnpm\b[^\n`]*\badd\b[^\n`]*(?<![\w@/-])react(?:-dom)?@'
match: contains
---

CA15 : le gestionnaire détecté d'après `pnpm-lock.yaml` est pnpm : « Plan de montée » donne des commandes `pnpm add … react@<version>` (avec ou sans `--filter`).
