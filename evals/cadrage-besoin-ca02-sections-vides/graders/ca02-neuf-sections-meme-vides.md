---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^#{1,6} +(\d+\.? +)?Synthèse *$[\s\S]*^#{1,6} +(\d+\.? +)?Contexte et objectifs *$[\s\S]*^#{1,6} +(\d+\.? +)?Utilisateurs et rôles *$[\s\S]*^#{1,6} +(\d+\.? +)?Besoins fonctionnels *$[\s\S]*^#{1,6} +(\d+\.? +)?Contraintes *$[\s\S]*^#{1,6} +(\d+\.? +)?Hors périmètre *$[\s\S]*^#{1,6} +(\d+\.? +)?Hypothèses *$[\s\S]*^#{1,6} +(\d+\.? +)?Questions au client *$[\s\S]*^#{1,6} +(\d+\.? +)?Points non déterminés *$'
flags: m
match: contains
---

004-CA2 : même quand la source ne donne rien pour certaines d'entre elles, les neuf sections contractuelles sont présentes, avec leurs noms exacts, dans l'ordre de la spec.
