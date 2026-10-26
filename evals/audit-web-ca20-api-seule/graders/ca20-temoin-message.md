---
type: regex
target: last_message
pattern: 'front|interface web|application web|pas de (?:site|page)|aucun(?:e)? (?:page|gabarit|composant)'
flags: "i"
match: contains
---

Témoin positif de CA20 : le dernier message explique la situation (il n'y a pas de front web JS/TS (API seule)). Sans lui, les correcteurs d'absence réussiraient même si la skill ne s'était pas déclenchée.
