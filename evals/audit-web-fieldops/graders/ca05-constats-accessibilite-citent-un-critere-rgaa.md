---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Accessibilit[ée][^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?!(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?(?:[1-9]|1[0-3])\.\d{1,2}(?![.\d])|RGAA\s+(?!4\.1(?![.\d]))(?:[1-9]|1[0-3])\.\d{1,2}(?![.\d])|crit[èe]re\s+(?:RGAA\s+)?(?:[1-9]|1[0-3])\.\d{1,2}(?![.\d]))))'
flags: "i"
match: not_contains
---

CA5 : chaque constat de la section « Accessibilité » cite le numéro d'un critère RGAA 4.1 (ex. « RGAA 1.1 »).
