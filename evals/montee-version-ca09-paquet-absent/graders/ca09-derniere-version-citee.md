---
type: regex
target: last_message
pattern: 'derni[èe]re version[^\n]{0,60}?\b\d+\.\d+\.\d+\b'
flags: i
match: contains
---

CA9 : le paquet existe sur le registre npm ; le dernier message cite sa dernière version publiée, désignée comme telle (« dernière version … x.y.z »), sans valeur figée.
