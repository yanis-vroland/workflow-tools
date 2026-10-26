---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{3,4} [^\n]*\bW\d+\b[^\n]*\n(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:RGAA\s+(?:4\.1\s*[,:–-]?\s*(?:crit[èe]re\s+)?)?|crit[èe]re\s+(?:RGAA\s+)?)8\.5(?![.\d])))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:index\.html))(?=(?:(?!\n#{1,4} )[\s\S])*?(?:(?:\broutes?\b[^\n]{0,15}?\x60?/(?![\w/])|toutes les (?:routes|vues|pages))))'
flags: "i"
match: contains
---

CA9 : le constat RGAA 8.5 cite le fichier `src/web/index.html` et la route concernée (« / », ou « toutes les routes » de l'application monopage servie par ce seul document).
