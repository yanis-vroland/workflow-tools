---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?<=[;&|(]\s*|\\n\s*|:\s*"|\b(?:then|do)\s+)(?:npm (?:install|ci|i|test|run|start)\b|yarn (?:install|test|run)\b|pnpm (?:install|i|test|run)\b|npx |(?:fvm )?flutter (?:pub get|test|run|build)\b|dart (?:pub get|test|run)\b|docker(?:-compose| compose)? (?:up|build|run)\b|vitest\b)'
min: 0
max: 0
---

CA1 et hors périmètre : ni installation des dépendances, ni exécution du projet ou de ses tests (qui modifieraient le projet). La consultation du registre (npm view, npm outdated) reste permise.
