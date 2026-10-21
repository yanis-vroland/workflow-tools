---
type: tool_used
tool: Read
input_match: '"file_path"\s*:\s*"[^"]*(?:notes/|brief-fieldops|notes-appel)'
min: 0
max: 0
---

007-CA2 : sans argument, l'outil ne choisit pas lui-même des notes dans le projet (ni `notes/`, ni le brief, ni les notes d'appel) : il demande la source.
