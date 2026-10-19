---
type: regex
target: last_message
pattern: 'code source|aucune? (?:fichier de code|code|spec)'
flags: "i"
match: contains
---

Témoin positif de CA19 : le dernier message explique que le répertoire ne
contient ni code source ni spec. Sans lui, les correcteurs d'absence
réussiraient même si la skill ne s'était pas déclenchée.
