---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"([^"]*[;&|(]\s*)?(sudo\s+|env\s+|npx\s+|\w+=\S*\s+)*(psql|pg_restore|sqlite3|mysql|prisma|typeorm|knex|sequelize|drift_dev|npm|node|dart|flutter)\b'
min: 0
max: 0
---

017-CA15 : aucune commande n'exécute une requête, une migration, les données de test, un client de base de données ou un outil d'ORM.
