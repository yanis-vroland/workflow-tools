---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\bchangeme\b|maps\.example\.invalid|mail\.example\.invalid|payments\.example\.invalid|no-reply@|10\.0\.2\.2'
match: not_contains
---

CA6 : le guide ne recopie aucune valeur de `.env.example` (valeurs factices `changeme`, URL des services, expéditeur), ni la valeur passée par `--dart-define` dans `mobile/README.md` (`10.0.2.2`).
