---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?:(?:[^"\\]|\\.)*?(?:\bsed(?:[^"\\|;&]|\\.)*?\s(?:-[A-Za-z]*i|--in-place)|\bperl(?:[^"\\|;&]|\\.)*?\s-[A-Za-z]*i|\btee\s+(?:-a\s+)?(?!/dev/null(?![\w/.-])|(?:\\"|'')?(?:\./)?docs/wf/)[^\s;&|)]|[\s(]\d?>>?\|?\s*(?!&|/dev/null(?![\w/.-])|(?:\\"|'')?(?:\./)?docs/wf/)(?:\\"|'')?[A-Za-z_$~./])|(?:(?:[^"\\]|\\.)*?(?:[;&|({`]|\$\(|\\n|\b(?:then|do|else)\s))?\s*(?:sudo\s+)?(?:rm|mv|cp|touch|truncate|ln|chmod|install)\s)'
min: 0
max: 0
---

CA1 : aucune commande Bash ne crée ni ne modifie un fichier du projet (`sed -i`, `tee`, redirection hors `/dev/null`, `rm`, `mv`, `cp`, `touch`…), en particulier ni manifeste ni lockfile.
