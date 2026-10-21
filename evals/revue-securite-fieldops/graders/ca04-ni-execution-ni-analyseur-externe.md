---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:(?:[^"\\]|\\.)*?(?:[;&|(`{]|\\n|\$\(|-c\s+(?:\\"|'')))?\s*(?:(?:env|sudo|time|nohup|exec|xargs|timeout|command)(?:\s+-{1,2}[\w-]+(?:[= ][\w.]+)?)*\s+)*(?:\w+=\S*\s+)*(?:npm|npx|yarn|pnpm|node|tsx|vitest|flutter|dart|fvm|docker|semgrep|gitleaks|trufflehog|osv-scanner|snyk)(?![\w./"''\\-])'
min: 0
max: 0
---

CA4 et hors périmètre : aucune commande Bash n'exécute le projet, son installation, ses tests
ni un analyseur externe (npm, npx, yarn, pnpm, node, tsx, vitest, flutter, dart, docker, semgrep,
gitleaks, osv-scanner…), en tête de commande ou après `;`, `&&`, `|`, `(`, `$(`, `bash -c`, `env`,
`sudo`, `xargs` ou une affectation de variable. Un nom de paquet écrit en argument de la requête
OSV.dev (ex. `q_add "npm" 'vitest' '1.0.1'`) n'est pas une exécution et n'est pas compté :
c'est ce que comptait à tort la première version de ce correcteur.
