---
type: regex
target: { source: file, path: "docs/wf/audit-web.md" }
pattern: '\n#{1,2} [^\n]*Points non d[ée]termin[ée]s[^\n]*\n(?:(?=(?:(?!\n#{1,2} )[\s\S])*?contrats)(?=(?:(?!\n#{1,2} )[\s\S])*?devis)(?=(?:(?!\n#{1,2} )[\s\S])*?equipes)(?=(?:(?!\n#{1,2} )[\s\S])*?stocks)|(?:(?!\n#{1,2} )[\s\S])*?src/web/legacy/?(?![\w/]))'
match: contains
---

CA27 : « Points non déterminés » liste tous les dossiers non lus : les quatre sous-dossiers de src/web/legacy/ (contrats, devis, equipes, stocks), ou le dossier src/web/legacy/ lui-même. En lister un seul (Glob tronqué à une centaine de fichiers) est un échec.
