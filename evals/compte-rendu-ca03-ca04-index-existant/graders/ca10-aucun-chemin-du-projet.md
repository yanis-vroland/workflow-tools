---
type: regex
target: { source: file, path: "docs/wf/compte-rendu/2026-10-07-point-hebdomadaire.md" }
pattern: '(src|mobile|lib)/[\w./-]+|docs/specs|package(-lock)?\.json|pubspec\.(yaml|lock)|Dockerfile|README\.md|[\w-]+\.(tsx?|dart|sql)\b'
match: not_contains
---

007-CA10 : le compte rendu ne cite aucun fichier du projet ; les notes n'en citent aucun.
