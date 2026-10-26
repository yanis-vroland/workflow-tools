---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA14. Les versions majeures récentes de `react-dom` déclarent `react` en dépendance pair à la même version majeure (métadonnées du registre npm).

PASS si, dans « Plan de montée », l'étape qui monte `react-dom` vers sa version visée monte aussi `react` vers la même version majeure, ou si une étape précédente le fait.

FAIL si `react-dom` est monté dans une étape sans que `react` soit monté à la même version majeure dans cette étape ou avant.
