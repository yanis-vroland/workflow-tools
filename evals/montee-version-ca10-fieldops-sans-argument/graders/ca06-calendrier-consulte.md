---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?endoflife\.date'
min: 1
---

CA6 : le calendrier de fin de support est demandé à endoflife.date (l'appel peut échouer si le domaine n'est pas autorisé : le correcteur ca06-fin-de-support vérifie alors le repli « non déterminé »).
