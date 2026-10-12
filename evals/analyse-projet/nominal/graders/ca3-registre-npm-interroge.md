---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:[^"\\]|\\.)*?(?:\bcurl\b(?:[^"\\]|\\.)*?registry\.npmjs\.org|\bnpm\s+(?:-\S+\s+)*(?:view|v|show|info|outdated)(?![\w-]))'
min: 1
---

CA3 : la dernière version des dépendances npm est obtenue en interrogeant le registre (`curl … registry.npmjs.org`, ou `npm view|show|info|outdated`), pas déduite des connaissances du modèle. Le motif porte sur la commande Bash elle-même : l'adresse du registre lue dans `package-lock.json` (champs `resolved`) ne suffit pas.
