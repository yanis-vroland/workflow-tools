---
type: regex
target: last_message
pattern: 'Flutter'
flags: "i"
match: contains
---

Témoin positif de CA20 : le dernier message explique la situation (il n'y a qu'une application Flutter, sans front web JS/TS). Sans lui, les correcteurs d'absence réussiraient même si la skill ne s'était pas déclenchée.
