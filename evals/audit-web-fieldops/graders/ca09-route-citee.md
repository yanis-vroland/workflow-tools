---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA9 : le projet est une application monopage (un seul document `src/web/index.html`, sans `<title>` ni meta
description).

PASS si les constats portant sur le titre absent (accessibilité, critère RGAA 8.5, et référencement) citent à
la fois le fichier `src/web/index.html` et la route concernée (par exemple « / », la page d'accueil, ou
« toutes les routes de l'application monopage »). FAIL si l'un de ces constats ne cite pas de route.
