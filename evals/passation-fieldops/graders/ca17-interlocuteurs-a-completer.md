---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Synth[èe]se[^\n]*\n(?:(?!\n##? )[\s\S])*?Interlocuteurs[^\n]*\n(?:[ \t]+[-*] [^\n]*(?:responsable|prestataire|repreneur)[^\n]*:\s*à compléter[ \t]*\n){2,}'
flags: "i"
match: contains
---

CA17 : la Synthèse désigne les interlocuteurs par leur rôle (responsable côté client, prestataire sortant, repreneur), au moins deux, chacun avec le champ « à compléter ». L'absence de nom de personne et d'adresse e-mail est vérifiée par `ca17-aucun-nom-de-contributeur` et `ca17-aucune-adresse-email`.

Remplace le correcteur `llm` `ca17-interlocuteurs-par-role`, bruité sur ce long livrable (votes FAIL FAIL FAIL sur un livrable conforme, série r8).
