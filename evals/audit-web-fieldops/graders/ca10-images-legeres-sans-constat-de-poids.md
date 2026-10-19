---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:logo|technician)\.svg))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:\bKo\b|octets|poids|lourde?)))'
flags: "i"
match: not_contains
---

CA10, faux positif : les images de moins de 200 Ko (logo.svg, technician.svg) ne font l'objet d'aucun constat de poids.
