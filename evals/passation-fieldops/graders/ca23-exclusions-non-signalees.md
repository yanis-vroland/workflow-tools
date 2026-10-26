---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '(?<=\n)(?=[^\n]*à paramétrer au redéploiement)[^\n]*(?:vite\.config|api_client\.dart|localhost|127\.0\.0\.1|docker-compose|\.env\.example|README|\bdb\b|\.svg|AndroidManifest|Info\.plist)'
flags: "i"
match: not_contains
---

CA23 : aucune ligne « à paramétrer au redéploiement » ne porte sur une adresse exclue par la spec : adresses locales (`localhost` dans `vite.config.ts` et `mobile/lib/services/api_client.dart`), service interne `db` de `docker-compose.yml`, `.env.example`, documentation (`README.md`, `mobile/README.md`), ni sur un identifiant qui n'est pas une adresse à joindre (espaces de noms des `.svg`, de `AndroidManifest.xml` et de `Info.plist`).

Remplace le correcteur `llm` `ca23-exclusions`, bruité sur ce long livrable (votes FAIL FAIL PASS sur un livrable conforme).
