---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"([^"]*[;&|(]\s*)?(sudo\s+|env\s+|npx\s+|\w+=\S*\s+)*(psql|pg_restore|sqlite3|mysql|prisma|typeorm|knex|sequelize|drift_dev|npm|node|dart|flutter|docker)\b'
min: 0
max: 0
---

017-CA15 : aucune commande n'exécute la migration, un client de base de données, un outil d'ORM ou le projet.
