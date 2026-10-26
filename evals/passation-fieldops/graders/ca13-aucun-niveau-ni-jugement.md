---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:\b(?:critiques?|élevée?s?|faibles?|moyens?|moyennes?|majeure?s?|mineure?s?|bloquante?s?|prioritaires?|urgente?s?|fragiles?|dette|obsolètes?|risques?|gravité)\b|🔴|🟠|🟡|🟢)'
flags: "i"
match: not_contains
---

CA13 : « Points d'attention » n'attribue aucun niveau de risque, de gravité ou de priorité (mots ou pastilles de couleur) et ne porte aucun jugement (« fragile », « dette », « obsolète »).

Avec `ca13-chaque-point-cite-son-fichier`, remplace le correcteur `llm` `ca13-faits-verifiables`, bruité sur ce long livrable (votes FAIL FAIL FAIL sur un livrable conforme, série r14).
