---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?Node)(?=(?:(?!\n## )[\s\S])*?\.nvmrc)(?=(?:(?!\n## )[\s\S])*?18\.19\.0)(?=(?:(?!\n## )[\s\S])*?\bengines\b)(?=(?:(?!\n## )[\s\S])*?Dockerfile)'
match: contains
---

CA4 : même sans réseau, la version de Node.js est citée avec les fichiers qui la déclarent (`.nvmrc`, `engines`, `Dockerfile`).
