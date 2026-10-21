---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Secrets et configuration[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?map_service\.dart[^\n]{0,15}\b4\b)(?=(?:(?!\n###? )[\s\S])*?élevé)'
match: contains
---

CA14 : la valeur littérale affectée à `mapApiKey` (`mobile/lib/services/map_service.dart`, ligne 4,
fichier `.dart` suivi par git) donne un constat de niveau élevé.
