---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bS\d+\b)(?=[^\n]*\bexpress\b)(?=[^\n]*4\.18\.2)(?=[^\n]*(?:CVE-\d{4}-\d+|GHSA-[0-9a-z]{4}-))'
match: contains
---

CA5 : « Dépendances vulnérables » cite express 4.18.2 (version installée du lockfile), visée par
des avis publiés de longue date, avec son identifiant `Sn` et l'identifiant d'un avis (CVE ou
GHSA), sur une même ligne. On ne vérifie aucune valeur d'avis précise (ADR-001).
