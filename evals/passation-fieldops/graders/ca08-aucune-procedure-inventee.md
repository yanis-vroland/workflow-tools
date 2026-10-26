---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Secrets [àa] transmettre[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:openssl|pwgen|\bgénér|\bconsole\b|tableau de bord|dashboard|demander au|interface d.administration|paramètres du compte)'
flags: "i"
match: not_contains
---

CA8 : aucune procédure d'obtention n'est inventée (commande de génération, console, tableau de bord, démarche).

Remplace, avec les autres correcteurs `ca08-*`, le juge `llm` `ca08-colonnes-etablies`, bruité sur ce long livrable (série r17 : votes FAIL FAIL PASS sur un livrable conforme pour CA8).
