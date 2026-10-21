---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*D[ée]pendances vuln[ée]rables[^\n]*\n(?:(?!\n## )[\s\S])*?(?<=\n)(?=[^\n]*\bS\d+\b)(?=[^\n]*\bhttp\b)(?=[^\n]*0\.12\.2)(?=[^\n]*(?:GHSA-4rgh-jx4f-qfcq|CVE-2020-35669))(?=[^\n]*0\.13\.3)(?=[^\n]*\bpub\b)'
flags: 'i'
match: contains
---

CA5 : « Dépendances vulnérables » cite http 0.12.2 (écosystème pub) avec son identifiant `Sn`,
l'avis GHSA-4rgh-jx4f-qfcq ou CVE-2020-35669 et la première version corrigée 0.13.3, sur une ligne.
