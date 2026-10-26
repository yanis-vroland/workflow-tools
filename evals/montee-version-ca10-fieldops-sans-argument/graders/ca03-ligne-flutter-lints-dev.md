---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*flutter_lints[^\n]*\^2\.0\.3[^\n]*?\b2\.0\.3\b[^\n]*\b(?:[3-9]|\d\d)\.\d+\.\d+\b[^\n]*\bmajeur\b[^\n]*\bdev_dependencies\b'
match: contains
---

CA3 : la ligne de `flutter_lints` donne sa contrainte, sa version installée, une dernière version publiée plus récente, l'écart « majeur » et l'usage `dev_dependencies`.
