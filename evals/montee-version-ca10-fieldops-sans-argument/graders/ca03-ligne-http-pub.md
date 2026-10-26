---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*(?<![\w/.-])http(?![\w:-])[^\n]*\^0\.13\.6[^\n]*?\b0\.13\.6\b[^\n]*\b[1-9]\d*\.\d+\.\d+\b[^\n]*\bmajeur\b[^\n]*(?<![\w_])dependencies\b'
match: contains
---

CA3 : la ligne du paquet pub `http` donne sa contrainte (`^0.13.6`), sa version installée tirée de `pubspec.lock` (0.13.6), une dernière version publiée d'une version majeure supérieure, l'écart « majeur » et l'usage `dependencies`.
