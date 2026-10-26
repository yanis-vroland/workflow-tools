---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n### [^\n]*(?:apps/web|@fieldops/web)'
match: contains
---

CA27 : « Inventaire des versions » a une sous-section pour l'application `apps/web`.
