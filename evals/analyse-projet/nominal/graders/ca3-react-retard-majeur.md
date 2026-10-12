---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Stack et dépendances[^\n]*\n(?:(?!^#+ [^\n]*Architecture)[\s\S])*?(?:react[^\n]*17\.0\.2[^\n]*(?:1[89]|[2-9]\d)\.\d+\.\d+|react[^\n]*(?:1[89]|[2-9]\d)\.\d+\.\d+[^\n]*17\.0\.2)'
flags: m
match: contains
---

CA3 : « Stack et dépendances » cite react avec sa version installée (17.0.2, lockfile) et une dernière version publiée d'au moins une version majeure au-dessus, sans figer sa valeur (ADR-001, réseau réel).
