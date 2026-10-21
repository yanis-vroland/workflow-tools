---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"git diff --name-only --end-of-options v1\.3\.0 HEAD"'
min: 1
---

CA16 : les fichiers modifiés depuis la référence sont établis par `git diff --name-only --end-of-options v1.3.0 HEAD`.
