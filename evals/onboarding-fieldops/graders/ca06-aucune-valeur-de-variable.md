---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\bchangeme\b|maps\.example\.invalid|mail\.example\.invalid|payments\.example\.invalid|no-reply@|10\.0\.2\.2|\b2027-03-31\b'
match: not_contains
---

CA6 : le guide ne recopie aucune valeur de `.env.example` (valeurs factices `changeme`, URL des services, expéditeur, date d'expiration de la clé de cartographie), ni la valeur passée par `--dart-define` dans `mobile/README.md` (`10.0.2.2`).
