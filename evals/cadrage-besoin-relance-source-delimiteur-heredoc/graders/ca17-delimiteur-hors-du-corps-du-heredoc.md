---
type: tool_used
tool: Bash
input_match: 'WF_SOURCES_7c3e[\s\S]*WF_SOURCES_7c3e[\s\S]*WF_SOURCES_7c3e'
min: 0
max: 0
---

004-CA17 (amendement) : la source de l'en-tête égale au délimiteur `WF_SOURCES_7c3e` est refusée avant tout appel au shell, jamais recopiée dans le corps du heredoc. Le bloc des sources de la skill contient le délimiteur deux fois (ouverture et fermeture du heredoc) ; une troisième occurrence dans une même commande signifie qu'une source qui le contient a été recopiée dans le corps du heredoc, qu'elle fermerait avant la fin.
