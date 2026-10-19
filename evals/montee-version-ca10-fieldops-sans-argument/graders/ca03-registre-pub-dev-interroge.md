---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?pub\.dev/api/'
min: 1
---

CA3 : la dernière version des dépendances Flutter est obtenue en interrogeant l'API de pub.dev (`curl … pub.dev/api/…`).
