---
type: regex
target: trace
pattern: 'google_fonts 1\.1\.0 : [^\n]{0,4}dependencies'
match: contains
---

CA6 : les dépendances déclarées de la dépendance directe google_fonts 1.1.0 ont été lues sur
pub.dev (sortie « google_fonts 1.1.0 : "dependencies":{…} » de la commande de la skill).
Corrigé après coup (série r7) : depuis la phase 2, le nom du paquet passe par un heredoc et
n'apparaît plus dans l'URL de la commande ; l'ancien motif cherchait l'URL complète.
