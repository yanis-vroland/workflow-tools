---
type: llm
focus: { source: file, path: "docs/wf/specs-tickets.md" }
---

006-CA14. Le projet contient exactement ces fichiers (hors `mobile/android/`, `mobile/ios/` et `node_modules/`) :

`.env.example`, `.eslintrc.json`, `.github/workflows/deploy.yml`, `.github/workflows/purge.yml`, `.gitignore`, `.nvmrc`, `docker-compose.yml`, `Dockerfile`, `docs/specs/001-interventions.md`, `docs/specs/002-ordres-de-travail.md`, `docs/specs/003-export-pdf.md`, `docs/wf/cadrage-besoin.md`, `mobile/.fvmrc`, `mobile/analysis_options.yaml`, `mobile/lib/db/local_db.dart`, `mobile/lib/main.dart`, `mobile/lib/models/intervention.dart`, `mobile/lib/models/intervention.g.dart`, `mobile/lib/screens/intervention_detail_screen.dart`, `mobile/lib/screens/intervention_list_screen.dart`, `mobile/lib/services/api_client.dart`, `mobile/lib/services/auth_service.dart`, `mobile/lib/utils/duration_format.dart`, `mobile/pubspec.lock`, `mobile/pubspec.yaml`, `mobile/README.md`, `mobile/test/duration_format_test.dart`, `package-lock.json`, `package.json`, `public/img/logo.svg`, `public/img/technician.svg`, `README.md`, `src/api/db.ts`, `src/api/middleware/auth.ts`, `src/api/routes/auth.ts`, `src/api/routes/interventions.ts`, `src/api/routes/technicians.ts`, `src/api/routes/workOrders.ts`, `src/api/server.ts`, `src/db/schema.sql`, `src/db/seed.ts`, `src/domain/invoice.test.ts`, `src/domain/invoice.ts`, `src/domain/scheduling.ts`, `src/domain/types.ts`, `src/jobs/purge-closed-interventions.ts`, `src/services/mailer.ts`, `src/services/mapClient.ts`, `src/services/payment.ts`, `src/web/api.ts`, `src/web/App.tsx`, `src/web/index.html`, `src/web/main.tsx`, `src/web/pages/InterventionList.tsx`, `src/web/pages/NewIntervention.tsx`, `tsconfig.json`, `vite.config.ts`.

Pour chaque ticket :

- la rubrique « Fichiers concernés » cite au moins un chemin (elle n'indique pas « non applicable », le projet ayant du code) ;
- chaque chemin cité figure dans la liste ci-dessus, ou est explicitement marqué « à créer » ;
- un ticket portant sur le filtrage par technicien ou la désactivation d'un technicien cite au moins un fichier existant pertinent (ex. `src/web/pages/InterventionList.tsx`, `src/api/routes/interventions.ts`, `src/api/routes/technicians.ts`, `src/db/schema.sql`).

Échoue si un chemin cité n'existe pas sans être marqué « à créer », ou si l'un de ces points est faux.
