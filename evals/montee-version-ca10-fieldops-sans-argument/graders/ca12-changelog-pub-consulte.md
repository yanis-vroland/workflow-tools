---
type: tool_used
tool: WebFetch
input_match: 'pub\.dev/packages/[a-z0-9_]+/changelog'
min: 1
---

CA12 : pour les écarts majeurs de l'application Flutter (http, geolocator, flutter_lints), la skill consulte le changelog officiel sur pub.dev, seule source de notes de version joignable dans la passe `reseau`. Sans ce correcteur, des ruptures toutes « non vérifiée » réussiraient sans qu'aucune source ait été tentée.
