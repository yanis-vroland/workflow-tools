---
type: regex
target: last_message
pattern: 'stack Python non couverte en v1'
flags: i
match: contains
---

CA18 : le dernier message indique « stack Python non couverte en v1 ». Témoin
positif : sans lui, les correcteurs d'absence réussiraient même si la skill ne
s'était pas déclenchée.
