---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA13. `_.pluck`, supprimé en lodash 4, est utilisé deux fois dans le projet (`src/index.ts` ligne 7, `src/report.ts` ligne 5). PASS si la rupture correspondante cite ces deux fichiers avec leur ligne et donne un nombre total de 2 occurrences, et si toute autre rupture citée a ses impacts (fichiers, lignes, total) ou la mention « sans impact identifié ». FAIL sinon.
