---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?\bcurl\b(?:[^"\\]|\\.)*?registry\.npmjs\.org'
min: 1
---

CA3 : la dernière version des dépendances npm est obtenue en interrogeant le registre (`curl … registry.npmjs.org`), pas déduite des connaissances du modèle. L'adresse du registre lue dans `package-lock.json` (champs `resolved`) ne suffit pas : le motif porte sur la commande Bash.
