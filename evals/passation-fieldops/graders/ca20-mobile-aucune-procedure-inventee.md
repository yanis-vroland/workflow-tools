---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Environnements et d[ée]ploiement[^\n]*\n(?:(?!\n##? )[\s\S])*?\n### [^\n]*mobile/[^\n]*\n(?:(?!\n#{2,3} )[\s\S])*?(?:flutter build|fastlane (?!ni\b)|\bstores?\b|Play Console|App Store Connect|`(?:fvm )?flutter )'
flags: "i"
match: not_contains
---

CA20 et CA6 : la sous-section de l'application mobile n'invente aucune procédure de déploiement ou de publication (construction, outil de publication, store).

Remplace, avec les autres correcteurs `ca20-*`, le juge `llm` `ca20-mobile-sans-deploiement`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
