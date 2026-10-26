---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\b(?:React|Express|Node(?:\.js)?|Flutter|Dart|Vite|Vitest|TypeScript|PostgreSQL|ESLint)\s+v?\d+(?:\.\d+)*\b'
flags: "i"
match: not_contains
---

CA4 : la stack n'est pas décrite : aucune technologie du projet n'est donnée avec sa version (ex. React 17, Node.js 18, Flutter 3.13, PostgreSQL 15). Nommer une technologie pour établir un fait (dépendance citée comme indice d'un service, commande `docker`) n'est pas une description de la stack.

Avec `ca04-aucune-section-systeme`, remplace le correcteur `llm` `ca04-stack-et-architecture-non-decrites`, bruité sur ce long livrable (votes FAIL FAIL FAIL sur un livrable conforme, série r14).
