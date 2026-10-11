---
type: tool_used
tool: Bash
input_match: '"command": ?"(?:[^"]*(?:&&|\|\||;|\|) *)?(?:npm|npx|yarn|pnpm|flutter|fvm|dart|docker|docker-compose|make|node|tsx|vitest)\b'
max: 0
---

CA14 et hors périmètre : l'outil n'exécute ni le projet, ni ses tests, ni son installation.
