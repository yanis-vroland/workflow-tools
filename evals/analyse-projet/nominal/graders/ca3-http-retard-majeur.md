---
type: regex
target: { source: file, path: "docs/wf/analyse-projet.md" }
pattern: '^#+ [^\n]*Stack et dépendances[^\n]*\n(?:(?!^#+ [^\n]*Architecture)[\s\S])*?(?:\bhttp\b[^\n]*0\.13\.6[^\n]*\b[1-9]\d*\.\d+\.\d+|\bhttp\b[^\n]*\b[1-9]\d*\.\d+\.\d+[^\n]*0\.13\.6)'
flags: m
match: contains
---

CA3 : même vérification côté Flutter (registre pub.dev) : le paquet http, installé en 0.13.6 (pubspec.lock), est cité avec une dernière version majeure supérieure.
