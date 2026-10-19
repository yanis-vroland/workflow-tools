---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA12 : FieldOps contient 15 marqueurs TODO, FIXME ou HACK répartis dans 13
fichiers : 3 dans `src/api/routes/interventions.ts`, 1 dans chacun des 12
autres (`Dockerfile`, `mobile/android/app/build.gradle`,
`mobile/lib/screens/intervention_list_screen.dart`,
`mobile/lib/screens/intervention_detail_screen.dart`,
`mobile/lib/db/local_db.dart`, `mobile/lib/services/auth_service.dart`,
`src/web/api.ts`, `src/api/server.ts`, `src/api/routes/auth.ts`,
`src/domain/invoice.ts`, `src/domain/scheduling.ts`, `src/services/mailer.ts`).

Réussite si toutes les affirmations suivantes sont vraies dans « Points
d'attention » :
1. Le total de 15 marqueurs est donné.
2. Au plus 20 fichiers sont listés, chacun avec son nombre de marqueurs.
3. La liste est triée par nombre de marqueurs décroissant :
   `src/api/routes/interventions.ts` (3) vient en premier.
4. Les nombres donnés correspondent à ceux ci-dessus (au plus une erreur de
   comptage tolérée sur un fichier à 1 marqueur).
