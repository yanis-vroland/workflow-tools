---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\;&|]|\\.)*?\s(?:-[A-Za-z]*[oO](?![\w-])|--output(?![\w-])|--remote-name(?:-all)?(?![\w-]))(?!\s*(?:=\s*)?/dev/null(?![\w/.-]))'
min: 0
max: 0
---

CA1 : aucune interrogation de registre ou de source publique n'écrit de fichier (`curl -o`, `-O`, `--output` hors `/dev/null`) : seules les sorties standard sont lues.
