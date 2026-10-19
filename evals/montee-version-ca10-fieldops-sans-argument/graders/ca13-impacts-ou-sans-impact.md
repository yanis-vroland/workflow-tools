---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA13. PASS si, dans « Ruptures et impacts », chaque rupture (R1, R2…) soit cite chaque fichier et numéro de ligne où l'API concernée est utilisée par le projet, avec le nombre total d'occurrences, soit est indiquée « sans impact identifié ». En particulier, la suppression de `ReactDOM.render` (montée de react-dom en version 19 ou plus) cite `src/web/main.tsx` ligne 5.

FAIL si une rupture n'a ni liste d'impacts (fichiers et lignes, avec leur nombre total) ni mention « sans impact identifié ».
