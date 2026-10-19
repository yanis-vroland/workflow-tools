---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?Node)(?=(?:(?!\n## )[\s\S])*?\.nvmrc)(?=(?:(?!\n## )[\s\S])*?18\.19\.0)(?=(?:(?!\n## )[\s\S])*?\bengines\b)(?=(?:(?!\n## )[\s\S])*?Dockerfile)(?=(?:(?!\n## )[\s\S])*?\bLTS\b)'
match: contains
---

CA4 : « Inventaire des versions » cite la version de Node.js déclarée avec chacun des fichiers qui la déclarent (`.nvmrc` 18.19.0, `engines` de `package.json`, `Dockerfile`) et la dernière version LTS (publiée, ou « non déterminé » si le calendrier est injoignable).
