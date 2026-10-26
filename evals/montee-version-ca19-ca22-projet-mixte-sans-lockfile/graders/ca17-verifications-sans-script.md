---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA17. Le `package.json` du projet ne définit aucun script (ni test, ni lint, ni build) et le projet n'a aucun autre fichier qui en définisse.

PASS si toutes ces conditions sont réunies :
1. « Vérifications » indique qu'aucun script de test ni de build n'a été identifié dans le projet.
2. « Points non déterminés » le reprend.
3. Aucune commande de test, de lint ou de build n'est inventée, ni dans « Vérifications » ni dans les vérifications des étapes du plan (pas de `npm test`, `npm run build`, `npx tsc`, `vitest`, `jest`…).

FAIL si une telle commande est proposée, ou si l'absence de script n'est pas signalée.
