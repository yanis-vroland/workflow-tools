---
type: regex
target: last_message
pattern: 'code source|aucun (?:fichier de )?code'
flags: "i"
match: contains
---

Témoin positif de CA26 : le dernier message explique la situation (le répertoire ne contient aucun code source). Sans lui, les correcteurs d'absence réussiraient même si la skill ne s'était pas déclenchée.
