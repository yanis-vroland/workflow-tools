---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)[ \t]*[-*] \*\*(?![^\n]*`[^`\n]*[./][^`\n]*`)[^\n]*'
match: not_contains
---

CA7 : chaque service listé cite au moins un fichier qui établit son usage (chemin entre accents graves).

Remplace, avec les autres correcteurs `ca07-*`, le juge `llm` `ca07-chaque-service-source`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
