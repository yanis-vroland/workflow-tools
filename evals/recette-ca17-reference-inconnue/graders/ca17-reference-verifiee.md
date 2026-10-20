---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"git log -1 --format=%h --end-of-options v9\.9\.9 --"'
min: 1
---

CA17 : la référence est vérifiée dans le dépôt (`git log -1 --format=%h --end-of-options v9.9.9 --`)
avant toute conclusion. Témoin positif : sans lui, les correcteurs d'absence
réussiraient même si la skill ne s'était pas déclenchée.
