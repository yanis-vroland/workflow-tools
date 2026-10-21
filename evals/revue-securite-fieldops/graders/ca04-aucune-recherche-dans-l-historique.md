---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bgit\s+(?:log|show|grep|blame|reflog|rev-list)\b'
min: 0
max: 0
---

CA4 et hors périmètre : aucune recherche dans l'historique git (`git log`, `git show`,
`git grep`, `git blame`, `git reflog`, `git rev-list`).
