---
type: regex
target: trace
pattern: 'injoignable \(curl \d+|curl: \(\d+\)'
match: contains
---

Témoin : la trace contient la sortie d'une interrogation d'OSV.dev qui a échoué faute de réseau
(`osv.dev injoignable (curl <code>…)` affiché par la commande de la skill, ou `curl: (<code>)`).
Sans lui, la base n'a pas été constatée injoignable (cas lancé avec une autorisation
WebFetch(domain:…), ou base jamais interrogée) et le cas ne prouve rien.
