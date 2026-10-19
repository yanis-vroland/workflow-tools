---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?pnpm-lock\.yaml)(?=(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w@/-])react(?![\w-])[^\n]*\^17\.0\.2[^\n]*?\b17\.0\.2\b)(?=(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w@/-])react(?![\w-])[^\n]*\^18\.2\.0[^\n]*?\b18\.2\.0\b)'
match: contains
---

CA3 : les versions installées sont tirées de `pnpm-lock.yaml` (react 17.0.2 dans une application, 18.2.0 dans l'autre, avec leur contrainte déclarée).
