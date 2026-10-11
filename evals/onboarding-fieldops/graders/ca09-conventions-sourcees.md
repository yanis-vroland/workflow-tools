---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA9 : FieldOps contient `.eslintrc.json`, `mobile/analysis_options.yaml` et
`.github/workflows/deploy.yml` (jobs : `npm ci`, `npm run lint`, `npm test`),
mais ni `CONTRIBUTING.md`, ni hook git, ni modèle de PR, ni configuration de
formatage.

Réussite si toutes les affirmations suivantes sont vraies dans « Contribuer » :
1. Chaque convention résumée cite le fichier d'où elle provient.
2. Les vérifications de CI à passer (lint et tests) sont données en citant
   `.github/workflows/deploy.yml`.
3. Aucune règle de nommage des branches ni de format des commits n'est
   présentée comme une convention du projet sans fichier source qui la définit ;
   leur absence est signalée (ex. « non déterminé ») ou elles ne sont pas citées.
4. Aucune commande de formatage n'est inventée (FieldOps n'en définit pas).
