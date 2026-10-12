---
type: llm
focus: { source: file, path: "docs/wf/onboarding.md" }
---

CA9 : le projet définit `npm run lint` (`package.json`, configuration
`eslint.config.js`), `npm run format` (`package.json`, configuration
`.prettierrc.json`) et un hook git `.husky/commit-msg` qui lance commitlint.

Réussite si toutes les affirmations suivantes sont vraies dans « Contribuer » :
1. La commande de lint `npm run lint` est donnée en citant `package.json`.
2. La commande de format `npm run format` est donnée en citant `package.json`.
3. Chaque convention résumée cite au moins un fichier du projet d'où elle
   provient (`CONTRIBUTING.md`, `commitlint.config.js`, `.husky/commit-msg`,
   `eslint.config.js`, `.prettierrc.json`, `package.json`).
4. Aucune convention n'est présentée sans fichier source.
