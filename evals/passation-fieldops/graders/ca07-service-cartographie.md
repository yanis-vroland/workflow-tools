---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:mapClient\.ts|\bMAP_API_(?:URL|KEY)\b)'
match: contains
---

CA7 : le service de cartographie est listé avec son indice (`src/services/mapClient.ts` ou les variables `MAP_API_*` de `.env.example`).
