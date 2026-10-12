---
type: regex
target: { source: file, path: "docs/wf/cadrage-besoin.md" }
pattern: '^[-*] *\**Sources lues\** *:.*compte-rendu-visio\.md`? *\(introuvable\)'
flags: m
match: contains
---

004-CA15 : la source introuvable `compte-rendu-visio.md` reste dans l'en-tête « Sources lues », marquée « (introuvable) », au lieu d'en être retirée.
