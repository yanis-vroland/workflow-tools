---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '(src|mobile|lib|public|android|ios)/[\w./-]+|docs/specs|package(-lock)?\.json|pubspec\.(yaml|lock)|Dockerfile|docker-compose\.yml|tsconfig\.json|vite\.config\.ts|README\.md|[\w-]+\.(tsx?|dart|sql)\b'
match: not_contains
---

004-CA22 : le livrable ne cite aucun fichier du code ou du projet existant (sources, manifestes, README, specs internes).
