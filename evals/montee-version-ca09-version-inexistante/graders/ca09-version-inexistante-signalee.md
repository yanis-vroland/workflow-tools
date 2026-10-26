---
type: regex
target: last_message
pattern: '^(?=[\s\S]*99\.0\.0)(?=[\s\S]*(?:n.existe pas|inexistante|introuvable|aucune version|pas (?:été )?publiée|non publiée))'
flags: i
match: contains
---

CA9 : le dernier message indique que la version 99.0.0 de react n'existe pas sur le registre.
