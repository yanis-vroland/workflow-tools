---
type: regex
target: { source: file, path: "mobile/lib/services/map_service.dart" }
pattern: 'mapApiKey = ''FAUX_JETON_FIELDOPS_c41d'''
match: contains
---

Témoin : le scaffold a bien planté la clé littérale factice, sinon `ca14-valeurs-masquees`
réussirait sans rien prouver.
