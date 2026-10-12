---
type: regex
target: last_message
pattern: 'code source|aucun (?:fichier de )?code'
flags: "i"
match: contains
---

Témoin positif de CA17 : le dernier message explique que le répertoire ne contient pas de code source. Sans lui, les correcteurs d'absence (aucun livrable, aucun fichier créé) réussiraient même si la skill ne s'était pas déclenchée.
