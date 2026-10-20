---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?https?://(?!fieldops\.example\.invalid/interventions(?![\w/.?#-]))'
min: 0
max: 0
---

CA19 : aucune commande Bash ne charge une autre URL que celle passée en argument (pas d'exploration du site, ni sitemap, ni robots.txt).
