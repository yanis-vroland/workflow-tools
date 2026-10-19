---
type: regex
target: last_message
pattern: 'lodash[\s\S]{0,300}?\b\d+\.\d+\.\d+\b|\b\d+\.\d+\.\d+\b[\s\S]{0,300}?lodash'
flags: i
match: contains
---

CA9 : le paquet existe sur le registre npm ; le dernier message cite sa dernière version publiée (version précise, sans valeur figée).
