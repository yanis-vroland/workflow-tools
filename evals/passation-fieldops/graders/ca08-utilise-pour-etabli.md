---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)\|[ \t]*`[A-Z0-9_]+`[ \t]*\|(?![ \t]*à compléter[ \t]*\|)(?![^|\n]*`[^`\n]+`)(?![^|\n]*\bl\. ?\d)[^|\n]*\|'
match: not_contains
---

CA8 : chaque « Utilisé pour » est soit « à compléter », soit établi avec le fichier (ou la ligne) qui le montre.

Remplace, avec les autres correcteurs `ca08-*`, le juge `llm` `ca08-colonnes-etablies`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
