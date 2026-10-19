---
type: llm
focus: { source: file, path: "docs/wf/chiffrage.md" }
---

005-CA15. Les évolutions portent sur du code existant (liste des interventions, routes d'API, envoi d'e-mails). Fichiers existants du projet, seuls valides :

`src/api/db.ts`, `src/api/middleware/auth.ts`, `src/api/routes/auth.ts`, `src/api/routes/interventions.ts`, `src/api/routes/technicians.ts`, `src/api/routes/workOrders.ts`, `src/api/server.ts`, `src/db/schema.sql`, `src/db/seed.ts`, `src/domain/invoice.test.ts`, `src/domain/invoice.ts`, `src/domain/scheduling.ts`, `src/domain/types.ts`, `src/services/mailer.ts`, `src/services/mapClient.ts`, `src/services/payment.ts`, `src/web/api.ts`, `src/web/App.tsx`, `src/web/index.html`, `src/web/main.tsx`, `src/web/pages/InterventionList.tsx`, `src/web/pages/NewIntervention.tsx`, `package.json`, et les fichiers de `mobile/`.

Dans « Détail par lot », chaque tâche qui modifie ou étend du code existant (ajout à la liste des interventions, à une route, au service d'e-mail…) cite dans sa colonne « Commentaire » au moins un fichier de cette liste, par son chemin. Aucun fichier cité dans le livrable comme existant n'est absent de cette liste (pas de fichier inventé présenté comme existant ; un fichier à créer peut être cité s'il est présenté comme nouveau).

Échoue si une tâche sur du code existant ne cite aucun fichier existant, ou si un fichier inexistant est présenté comme existant.
