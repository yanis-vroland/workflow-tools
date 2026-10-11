---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:\bnpm (?:install|ci|i|test|run|start)\b|\byarn (?:install|test|run)\b|\bpnpm (?:install|i|test|run)\b|\bnpx |\bflutter (?:pub get|test|run|build)\b|\bdart (?:pub get|test|run)\b|\bdocker(?:-compose| compose)? (?:up|build|run)\b|\bvitest\b)'
min: 0
max: 0
---

CA1 et hors périmètre : ni installation des dépendances, ni exécution du projet ou de ses tests (qui modifieraient le projet). La consultation du registre (npm view, npm outdated) reste permise.
