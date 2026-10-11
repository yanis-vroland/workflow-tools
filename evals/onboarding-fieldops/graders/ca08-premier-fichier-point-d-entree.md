---
type: regex
target: { source: file, path: "docs/wf/onboarding.md" }
pattern: '\n##? [^\n]*Se rep[ée]rer dans le code[^\n]*\n(?:(?!\n##? )(?!\n *1\. )[\s\S])*\n *1\. [^\n]*(?:src/api/server\.ts|src/web/main\.tsx|mobile/lib/main\.dart)'
match: contains
---

CA8 : le parcours de lecture commence par un point d'entrée de l'application (`src/api/server.ts`, `src/web/main.tsx` ou `mobile/lib/main.dart`).
