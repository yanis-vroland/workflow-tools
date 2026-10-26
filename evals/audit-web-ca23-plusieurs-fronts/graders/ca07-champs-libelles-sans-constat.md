---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '^(?![\s\S]*?(?:\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)11\.1(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:contact/page\.tsx\x60?(?:\s*[:,]\s*|\s*\(\s*|\s+)(?:l\.|lignes?|L)?\s*(?:\d+\s*(?:,|et|à|-)\s*)*[78](?!\d)))))(?=[\s\S]*?wf-audit-web)'
flags: "i"
match: contains
---

CA7, faux positif : les champs des lignes 7 (`<label htmlFor>`) et 8 (`aria-label`) de portail/app/contact/page.tsx sont libellés ; aucun constat RGAA 11.1 ne les cite.
