---
type: tool_used
tool: Read
input_match: '"file_path"\s*:\s*"(?![^"]*(?:reunions/notes-reunion\.md|docs/wf/compte-rendu/[^"/]+\.md)")'
min: 0
max: 0
---

007-CA10 : Read ne sert qu'au fichier de notes et aux fichiers de `docs/wf/compte-rendu/` ; aucun fichier du code (`src/`, `mobile/`, manifestes, README, specs internes) n'est lu.
