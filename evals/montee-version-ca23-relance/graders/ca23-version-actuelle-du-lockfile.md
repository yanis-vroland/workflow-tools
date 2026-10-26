---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w@/-])react(?![\w-])[^\n]*\^17\.0\.2[^\n]*?\b17\.0\.2\b'
match: contains
---

CA23 : l'inventaire reflète les versions actuelles (react `^17.0.2`, installé 17.0.2 d'après `package-lock.json`).
