---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:Dossiers analys[ée]s[^\n]*src/web/legacy))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA27 : la ligne « Dossiers analysés » de « Périmètre et méthode » ne cite aucun dossier non lu ou lu en partie (src/web/legacy/…) : ces dossiers ne figurent que dans « Points non déterminés ». Ajouté après l'eval r14, où l'audit les citait comme analysés.
