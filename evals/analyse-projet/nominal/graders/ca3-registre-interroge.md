---
type: regex
target: trace
pattern: 'registry\.npmjs\.org|npm (?:view|show|info|outdated)\b|pub\.dev/api|(?:dart|flutter) pub outdated'
match: contains
---

CA3 : la dernière version est obtenue en interrogeant le registre de paquets, pas déduite des connaissances du modèle.
