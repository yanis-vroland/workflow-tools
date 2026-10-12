---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] *\**Sources lues\** *:.*ancien-brief\.md`? *\(introuvable\)'
flags: m
match: contains
---

004-CA15 : la source `ancien-brief.md`, déjà introuvable à la relance précédente, reste dans l'en-tête marquée « (introuvable) ».
