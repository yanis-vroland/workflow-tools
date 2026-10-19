---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA14 et spec 017 (Livrable, niveau C). Le schéma existant `src/db/schema.sql` s'écarte des conventions fixes de la spec : `users` et `technicians` n'ont ni `created_at` ni `updated_at`, `work_orders` n'a pas `updated_at`, et `interventions` n'a pas `created_at`.

- La migration suit les conventions du schéma existant (elle n'ajoute pas d'office `created_at`/`updated_at` aux tables existantes pour les mettre aux conventions).
- « Revue du modèle » signale au moins les tables existantes sans `created_at` ou sans `updated_at`.

Échoue si la revue ne signale aucun de ces écarts, ou si la migration modifie les tables existantes pour les aligner sur les conventions sans que la demande le prévoie.
