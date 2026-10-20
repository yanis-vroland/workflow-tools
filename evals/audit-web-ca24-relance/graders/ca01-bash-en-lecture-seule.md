---
type: tool_used
tool: Bash
input_match: '"command"\s*:\s*"(?!(?:git rev-parse --short HEAD|git status --porcelain|date \+%F)"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls|-exec(?! wc -c \{\} \+)))(?:[^\"\\;&|><\x60$]|\\\\[()])*\"|find \.(?!(?:[^\"\\]|\\.)*?(?:-delete|-execdir|-ok|-fprint|-fls))(?:[^\"\\;&|><\x60$]|\\\\[()])* -exec dirname \{\} \+ \| sort \| uniq -c\")'
min: 0
max: 0
---

CA1 : Bash ne sert qu'aux commandes en lecture que la skill prescrit (voir le cas audit-web-fieldops).
