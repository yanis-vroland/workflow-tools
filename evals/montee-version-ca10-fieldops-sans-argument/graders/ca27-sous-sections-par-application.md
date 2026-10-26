---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?\n### [^\n]*(?:mobile|Flutter|compagnon))(?=(?:(?!\n## )[\s\S])*?\n### [^\n]*(?:web|API|racine|Node|back-office|JavaScript|TypeScript|npm))'
flags: i
match: contains
---

CA27 : FieldOps est un monorepo (application web à la racine, application Flutter dans `mobile/`) : « Inventaire des versions » a une sous-section `###` par application.
