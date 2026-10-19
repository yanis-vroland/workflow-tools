---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:|(?:[^"\\]|\\.)*?(?<![\w./"\\-]))(?:npm|npx|yarn|pnpm|node|tsx|vitest|flutter|dart|fvm|docker|semgrep|gitleaks|trufflehog|osv-scanner|snyk)(?![\w./"\\-])'
min: 0
max: 0
---

CA4 et hors périmètre : aucune commande Bash n'exécute le projet, son installation, ses tests
ni un analyseur externe (npm, npx, yarn, pnpm, node, flutter, dart, docker, semgrep, gitleaks,
osv-scanner…). Le nom d'écosystème `npm` écrit entre guillemets dans la requête JSON envoyée à
OSV.dev n'est pas une exécution et n'est pas compté.
