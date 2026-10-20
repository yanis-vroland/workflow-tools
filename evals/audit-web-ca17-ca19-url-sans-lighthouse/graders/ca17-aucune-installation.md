---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:\b(?:npm|pnpm|yarn|bun)\s+(?:install|i|add|ci|dlx|x)\b|\bnpx\b|\bpnpx\b|\bbunx\b|\bbrew\s+install\b|\bapt(?:-get)?\s+install\b|\bcorepack\b)'
min: 0
max: 0
---

CA17 : l'outil n'installe pas Lighthouse : ni `npm install`, ni `npx` (qui téléchargerait le paquet), ni autre gestionnaire.
