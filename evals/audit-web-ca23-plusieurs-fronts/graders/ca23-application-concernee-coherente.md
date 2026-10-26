---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA23 : le projet contient deux fronts web JS/TS : le back-office React (dossier `src/web/`) et le portail client
Next.js (dossier `portail/`).

PASS si chaque constat indique l'application concernée et que cette application correspond au fichier cité
(un fichier de `portail/` est rattaché au portail, un fichier de `src/web/` ou de `public/` au back-office), et
si « Périmètre et méthode » liste les deux applications. FAIL sinon.
