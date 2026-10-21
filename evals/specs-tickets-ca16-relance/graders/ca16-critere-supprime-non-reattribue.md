---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^#{2,5} +\**T02\** *:(?:(?!^#{2,3} )[\s\S])*?^[-*] *\**CA2\b'
flags: m
match: not_contains
---

006-CA16 : dans le ticket T02, le numéro de critère CA2, supprimé, n'est pas réattribué.
