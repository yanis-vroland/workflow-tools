---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?=(?:[^"\\]|\\.)*?\bcurl\b)(?=(?:[^"\\]|\\.)*?pub\.dev/api/packages/)'
min: 1
---

CA3 : la dernière version des dépendances Flutter est obtenue en interrogeant l'API de pub.dev, pas déduite des connaissances du modèle ni du `pubspec.lock`. La commande contient `curl` et l'adresse `pub.dev/api/packages/`, dans n'importe quel ordre : la skill construit l'adresse dans une variable avant l'appel `curl`.
