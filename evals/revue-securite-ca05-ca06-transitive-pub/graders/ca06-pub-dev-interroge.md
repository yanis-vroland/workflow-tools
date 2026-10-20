---
type: regex
target: trace
pattern: 'pub\.dev/api/packages/google_fonts/versions/1\.1\.0'
match: contains
---

CA6 : les dépendances déclarées de la dépendance directe google_fonts 1.1.0 ont été lues sur
pub.dev (pubspec.lock ne donne pas le lien).
