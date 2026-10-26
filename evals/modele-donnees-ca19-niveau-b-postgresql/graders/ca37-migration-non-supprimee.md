---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"[^"]*\b(rm|mv|unlink|truncate)\b[^"]*migration\.sql'
min: 0
max: 0
---

017-CA37 : l'outil ne supprime ni ne déplace `migration.sql`.
