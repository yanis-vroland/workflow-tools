---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*@types/react(?![\w-])[^\n]*\^17\.0\.70[^\n]*?\b17\.0\.70\b[^\n]*\b(?:1[89]|[2-9]\d)\.\d+\.\d+\b[^\n]*\bmajeur\b[^\n]*\bdevDependencies\b'
match: contains
---

CA3 : la ligne de `@types/react` donne sa contrainte, sa version installée, une dernière version publiée plus récente, l'écart « majeur » et l'usage `devDependencies`.
