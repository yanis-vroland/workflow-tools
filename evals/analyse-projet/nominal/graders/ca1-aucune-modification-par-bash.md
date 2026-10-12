---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:(?:[^"\\]|\\.)*?(?:\bsed(?:[^"\\|;&]|\\.)*?\s(?:-[A-Za-z]*i|--in-place)|\bperl(?:[^"\\|;&]|\\.)*?\s-[A-Za-z]*i|\btee\s+(?:-a\s+)?(?!/dev/null(?![\w/.-])|(?:\\"|'')?(?:\./)?docs/wf/)[^\s;&|)]|[\s(]\d?>>?\|?\s*(?!&|/dev/null(?![\w/.-])|(?:\\"|'')?(?:\./)?docs/wf/)(?:\\"|'')?[A-Za-z_$~./])|(?:(?:[^"\\]|\\.)*?(?:[;&|({`]|\$\(|\\n|\b(?:then|do|else)\s))?\s*(?:sudo\s+)?(?:rm|mv|cp|touch|truncate|ln|chmod|install)\s)'
min: 0
max: 0
---

CA1 : aucune commande Bash ne modifie ni ne crée un fichier du projet : ni `sed -i`, ni `perl -i`, ni `tee`, ni redirection `>`/`>>` (hors `/dev/null`, descripteurs `2>&1`, `>&2` et livrable sous `docs/wf/`), ni `rm`, `mv`, `cp`, `touch`, `truncate`, `ln`, `chmod`, `install` en position de commande. Le livrable s'écrit avec l'outil Write. Exemples positifs et négatifs vérifiés par `tests/correcteurs/wf-analyse-projet.mjs`.
