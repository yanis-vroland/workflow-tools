---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Inventaire des versions[^\n]*\n(?:(?!\n## )[\s\S])*?\n[^\n]*touch pwned[^\n]*(?:non vérifié|invalide|non conforme)'
flags: i
match: contains
---

CA3 (chaque dépendance directe a sa ligne) : la dépendance au nom non conforme figure dans l'inventaire, signalée comme non vérifiée (nom invalide, jamais envoyé au registre).
