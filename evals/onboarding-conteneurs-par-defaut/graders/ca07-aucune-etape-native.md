---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*(?:Installer|Lancer) le projet[^\n]*\n(?:(?!\n##? )[\s\S])*?\n\d+\.[^\n]*(?:npm (?:install|ci|i|start|run)\b|node src)'
match: not_contains
---

CA7 : une seule voie détaillée, aucune étape numérotée d'« Installer le projet »
ni de « Lancer le projet » ne suit la voie native.
