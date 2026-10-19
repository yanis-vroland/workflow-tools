---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA31. Le renommage de `report` en `visit_report` touche des fichiers du code qui utilisent cette colonne : au moins `src/api/routes/interventions.ts` (requête `UPDATE interventions SET status = $1, report = $2…`), `src/services/mailer.ts` (champ `report` envoyé au client), `src/domain/types.ts` (champ `report` du type), `mobile/lib/db/local_db.dart` (création de la table locale avec `report`) et `mobile/lib/models/intervention.dart` (champ `report` du modèle).

La section « Évolution » liste ces fichiers, chacun avec son chemin relatif et l'élément utilisé (colonne `report`, requête, champ). Elle peut en citer d'autres, à condition qu'ils utilisent réellement une table ou une colonne modifiée.

Échoue si l'un de ces cinq fichiers manque, ou si un fichier listé n'a pas son élément utilisé.
