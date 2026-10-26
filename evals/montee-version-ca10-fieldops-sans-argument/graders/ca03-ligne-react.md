---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w@/-])react(?![\w-])[^\n]*\^17\.0\.2[^\n]*?\b17\.0\.2\b[^\n]*\b(?:1[89]|[2-9]\d)\.\d+\.\d+\b[^\n]*\bmajeur\b[^\n]*(?<![\w-])dependencies\b'
match: contains
---

CA3 : dans « Inventaire des versions », la ligne de `react` donne, dans l'ordre, la contrainte déclarée (`^17.0.2`), la version installée tirée du lockfile (17.0.2), une dernière version publiée plus récente (18 ou plus, sans valeur figée), l'écart « majeur » et l'usage `dependencies`.
