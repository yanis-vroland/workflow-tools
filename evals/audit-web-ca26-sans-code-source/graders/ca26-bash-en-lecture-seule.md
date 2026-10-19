---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F|command -v lighthouse)"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls|-exec(?! wc -c \{\} \+)))(?:[^\"\\;&|><\x60$]|\\\\[()])*\"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls))(?:[^\"\\;&|><\x60$]|\\\\[()])* -exec dirname \{\} \+ \| sort \| uniq -c\"|lighthouse ''[^''\"]+'' (?:[^\"\\;&|><\x60$]|\\\\\")*\| node ''[^''\"]*/scripts/lighthouse-summary\.mjs''\")'
min: 0
max: 0
---

CA26 et hors périmètre : Bash ne sert qu'aux commandes en lecture que la skill prescrit (aucune installation, exécution ni écriture).
