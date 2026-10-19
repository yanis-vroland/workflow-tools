---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA8. L'outil a été lancé avec l'argument `react-dom 19`. `react-dom` 19 déclare `react` en dépendance pair à la même version (CA14).

PASS si toutes ces conditions sont réunies :
1. « Cibles retenues » ne contient que la montée de `react-dom` vers une version 19.x (éventuellement accompagnée de `react` 19.x, présenté comme entraîné par `react-dom`).
2. « Ruptures et impacts » et « Plan de montée » ne portent que sur `react-dom` et `react` : aucune autre dépendance (express, vite, http, geolocator…), ni Node.js, ni Flutter.

FAIL si une autre cible apparaît, ou si le plan monte une autre dépendance.
