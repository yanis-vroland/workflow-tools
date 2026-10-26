---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:osv\.dev|\b(?:npm|pnpm|yarn)\s+(?:-\S+\s+)*audit\b|github\.com/advisories|api\.github\.com/advisories|nvd\.nist\.gov|snyk)'
min: 0
max: 0
---

CA11 : l'outil ne recherche pas lui-même les vulnérabilités (ni OSV.dev, ni `npm audit`, ni base d'avis) ; il reprend seulement le livrable de `wf-revue-securite`.
