---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n#{2,4} [^\n]*(?:Stack|Architecture|Installation|Lancement|Composants)'
flags: "i"
match: not_contains
---

CA4 : le dossier ne contient aucune section ni sous-section qui décrive le système (stack, architecture, installation ou lancement locaux) : ce rôle revient à `wf-doc-projet`. Le schéma est exclu par `ca04-aucun-schema`.
