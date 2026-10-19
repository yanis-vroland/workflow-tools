---
type: llm
focus: { source: file, path: "docs/wf/passation.md" }
---

CA20 et CA6 : FieldOps est un monorepo. L'application web (racine) est déployée
par `.github/workflows/deploy.yml` ; l'application Flutter (`mobile/`) n'a
aucune configuration de déploiement ni de publication dans le dépôt.

Réussite si toutes les affirmations suivantes sont vraies :
1. « Environnements et déploiement » contient une sous-section pour l'application
   web et une pour l'application mobile.
2. La sous-section de l'application mobile n'invente aucune procédure de
   déploiement ou de publication (pas de `flutter build`, de `fastlane`, de
   publication sur un store) : elle indique que la procédure n'a pas été trouvée
   dans le dépôt.
3. « Services tiers et accès » contient aussi une sous-section par application.
