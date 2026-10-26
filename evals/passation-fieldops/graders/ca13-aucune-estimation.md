---
type: regex
target: { source: file, path: "docs/wf/passation.md" }
pattern: '\n##? [^\n]*Points d.attention[^\n]*\n(?:(?!\n##? )[\s\S])*?(?:\bjours?[- ]hommes?\b|\bj/h\b|criticit[ée]|\bscore\b|\b\d+\s*/\s*(?:10|20|100)\b)'
flags: "i"
match: not_contains
---

CA13 : « Points d'attention » ne contient ni estimation d'effort (jours-homme), ni criticité, ni note ou score.
