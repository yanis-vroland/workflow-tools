---
type: regex
target: trace
pattern: 'injoignable \(curl \d+\)|curl: \(\d+\)'
match: contains
---

Témoin : la trace contient la sortie d'une interrogation du registre qui a échoué faute de réseau (`<paquet> injoignable (curl <code>)` affiché par la commande de la skill, ou message `curl: (<code>)`). Sans ce témoin, le registre n'a pas été constaté injoignable et le cas ne prouve rien.
