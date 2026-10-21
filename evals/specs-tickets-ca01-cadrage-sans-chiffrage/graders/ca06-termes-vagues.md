---
type: regex
target: { source: file, path: "docs/wf/specs-tickets.md" }
pattern: '^[-*] *\**CA\d+\**\s*:(?![^\n]*\d)[^\n]*\b(rapides?|rapidement|simples?|simplement|intuitif|intuitive|intuitifs|intuitives|faciles?|facilement|conviviale?s?|performante?s?)\b'
flags: mi
match: not_contains
---

006-CA6 : aucune ligne de critère d'acceptation ne contient « rapide », « simple », « intuitif », « facile », « convivial » ou « performant » sans aucune valeur chiffrée sur la même ligne. Le cadrage contient « rapide » (Q02) et « intuitive » (Q04), questions restées ouvertes.
