---
type: regex
target: last_message
pattern: 'code source|r[ée]pertoire (?:est )?vide|aucun (?:fichier|code)'
flags: "i"
match: contains
---

Témoin positif de CA26 : le dernier message explique la situation (le répertoire est vide). Sans lui, les correcteurs d'absence réussiraient même si la skill ne s'était pas déclenchée.
