---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Services tiers et acc[èe]s[^\n]*\n(?:(?!\n##? )[\s\S])*?(?<=\n)(?=[^\n]*[Cc]artographie)(?=[^\n]*direction technique du client)'
match: contains
---

CA15 : le titulaire du compte de cartographie saisi à la main (« direction technique du client ») est conservé.
