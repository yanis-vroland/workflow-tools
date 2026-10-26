---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\n## Cibles retenues[^\n]*\n(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+(?:Node\.js|Flutter)\b(?:(?!\n## )[\s\S])*?\n(?:\d+[.)]|[-*])[ \t]+(?!Node\.js|Flutter)'
match: not_contains
---

CA10 : dans « Cibles retenues », les cibles d'environnement d'exécution et de SDK viennent après le lot et les cibles en écart majeur.
