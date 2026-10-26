---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?=(?:(?!\n## )[\s\S])*?\.node-version)(?=(?:(?!\n## )[\s\S])*?20\.11\.1)(?=(?:(?!\n## )[\s\S])*?\bLTS\b)'
match: contains
---

CA4 : Node.js 20.11.1 est cité avec le fichier qui le déclare (`.node-version`) et la dernière version LTS (publiée ou « non déterminé »).
