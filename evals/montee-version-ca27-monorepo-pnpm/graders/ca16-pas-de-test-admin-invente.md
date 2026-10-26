---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA16 et CA17. `apps/web` définit les scripts `test` et `build` ; `apps/admin` ne définit que `build`. PASS si « Vérifications » donne pour `apps/web` les commandes de test et de build, et pour `apps/admin` seulement celle de build, sans inventer de commande de test pour `apps/admin`. FAIL sinon.
