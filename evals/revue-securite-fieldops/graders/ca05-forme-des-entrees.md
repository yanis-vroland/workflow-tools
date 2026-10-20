---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?\n\| S\d+ \|(?! [^|\n]+ \| `[^`|\n]+` \| (?:npm|pub|Pub) \| [^|\n]*\d[^|\n]* \| (?:directe|transitive)[^|\n]* \| (?:GHSA-|CVE-|[A-Z]+-)[^|\n]* \| (?!(?:élevé|moyen|faible) )[^|\n]+ \| [^|\n]+ \|[ ]*(?:\n|$))'
match: not_contains
---

CA5 et CA10 : chaque ligne du tableau « Dépendances vulnérables » porte son identifiant `Sn`, son
application, le nom du paquet, l'écosystème (npm ou pub), une version, le lien (directe ou
transitive), un avis (GHSA, CVE ou identifiant OSV), une sévérité publiée (jamais la grille élevé,
moyen, faible) et une première version corrigée. Remplace un juge llm bruité (série r7).
