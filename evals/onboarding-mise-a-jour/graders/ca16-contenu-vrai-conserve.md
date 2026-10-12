---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA16 : l'ancien guide (en-tête daté du 2026-01-15) contenait notamment, toujours
vrais : Flutter 3.13.9 fixé par `mobile/.fvmrc` ; la commande `npm run db:seed`
pour charger les données de démonstration (`package.json`) ; le terme
`WorkOrder` défini comme la demande du client, qui peut donner lieu à plusieurs
interventions (`src/domain/types.ts`). Il contenait aussi une affirmation fausse :
Node.js 16.20.0 fixé par `.nvmrc` (le fichier contient 18.19.0).

Réussite si toutes les affirmations suivantes sont vraies dans le guide mis à
jour :
1. Les trois informations toujours vraies sont conservées (en substance).
2. L'affirmation fausse est corrigée (Node.js 18.19.0, `.nvmrc`).
3. La date de l'en-tête n'est plus 2026-01-15.
4. Le fichier contient un seul guide, pas deux versions successives.
