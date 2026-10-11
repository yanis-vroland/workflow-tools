---
type: regex
target: trace
pattern: 'injoignable \(curl \d+\)|curl: \(\d+\)'
match: contains
---

Témoin : la trace contient la sortie d'une interrogation du registre qui a échoué faute de réseau (`<paquet> injoignable (curl <code>)` affiché par la commande de la skill, ou message d'erreur `curl: (<code>)`). Le texte de la commande seule ne suffit pas : il porte `$rc`, jamais un code numérique. Sans ce témoin, le registre n'a pas été constaté injoignable (cas lancé avec une autorisation WebFetch(domain:…), ou registre jamais interrogé) et le cas ne prouve rien.
