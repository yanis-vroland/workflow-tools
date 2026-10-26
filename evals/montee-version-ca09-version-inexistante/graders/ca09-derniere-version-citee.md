---
type: regex
target: last_message
pattern: 'derni[èe]re version[^\n]{0,60}?\b(?:1[89]|[2-8]\d|9[0-8])\.\d+\.\d+\b'
flags: i
match: contains
---

CA9 : le dernier message cite la dernière version publiée de react, désignée comme telle (18 ou plus, sans valeur figée ; ni 99.0.0 demandée, ni 17.0.2 installée).
