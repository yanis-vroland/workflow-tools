---
type: regex
target: trace
pattern: 'injoignable \((?:curl|HTTP) \d+\)|curl: \(\d+\)'
match: contains
---

Témoin : la trace contient la sortie d'une interrogation du registre qui a échoué faute de réseau (`<paquet> injoignable (curl <code>)` ou `injoignable (HTTP <code>)` affichés par la commande de la skill, ou message `curl: (<code>)`). Le texte de la commande seule ne suffit pas : il porte `$rc` ou `$code`, jamais un nombre. Sans ce témoin, le registre n'a pas été constaté injoignable et le cas ne prouve rien.
