---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA14. `react-dom` 19 déclare `react` ^19 en dépendance pair. PASS si `react` est monté en version 19 dans la même étape que `react-dom` ou dans une étape qui la précède, et si le livrable indique que cette montée est exigée par `react-dom` (dépendance pair, métadonnées du registre). FAIL si `react` n'est pas monté, ou seulement dans une étape postérieure.
