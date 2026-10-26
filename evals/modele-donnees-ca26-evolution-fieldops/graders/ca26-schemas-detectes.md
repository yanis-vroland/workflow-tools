---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA26. Le projet contient deux schémas : `src/db/schema.sql` (SQL PostgreSQL, `CREATE TABLE` écrits à la main, sans outil de migration) et `mobile/lib/db/local_db.dart` (base locale sqflite, `openDatabase` en `version: 1`, création par `onCreate`, sans `onUpgrade`).

La section « Évolution » :

- cite chacun de ces deux schémas par son chemin ;
- indique pour `src/db/schema.sql` la base PostgreSQL et un outil de migration « aucun » (ou équivalent : aucun outil détecté) ;
- indique pour `mobile/lib/db/local_db.dart` sqflite et la montée de version de la base (`version` et `onUpgrade`) comme mécanisme de migration, ou « aucun » s'il le juge absent, sans inventer d'outil ;
- n'invente aucun autre schéma ni aucun ORM (pas de Prisma, TypeORM, Knex…).

Échoue si l'un des deux schémas manque, si un ORM ou un outil de migration est inventé, ou si un schéma inexistant est cité.
