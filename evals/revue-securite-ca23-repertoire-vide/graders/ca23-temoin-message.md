---
type: regex
target: last_message
pattern: 'code source|r[ée]pertoire (?:est )?vide|aucun (?:fichier|code)'
flags: 'i'
match: contains
---

Témoin positif de CA23 : le dernier message explique que le répertoire est vide ou sans code
source. Sans lui, les correcteurs d'absence réussiraient même si la skill ne s'était pas déclenchée.
