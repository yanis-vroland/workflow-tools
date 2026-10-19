---
type: llm
focus: { source: file, path: "docs/wf/recette.md" }
---

CA15 : le projet définit trois rôles (`admin`, `dispatcher`, `technician`,
dans `src/db/schema.sql` et `src/db/seed.ts`) et des données de démonstration
(`src/db/seed.ts`).

Réussite si « Prérequis » liste ces rôles (sous ce nom ou une traduction
évidente : administrateur, technicien), en précisant au moins ceux qu'utilisent
les cas, et cite le fichier de données de démonstration `src/db/seed.ts`.
Échec si les rôles ne sont pas listés ou si le fichier de données n'est pas cité.
