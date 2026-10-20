---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?!\n#{1,2} )[\s\S])*?(?:npm (?:install|i) (?:-g|--global) lighthouse|(?:pnpm|yarn) (?:add )?(?:-g|global) (?:add )?lighthouse)'
flags: "i"
match: contains
---

CA17 : « Points non déterminés » indique la commande d'installation de Lighthouse à lancer pour un audit mesuré.
