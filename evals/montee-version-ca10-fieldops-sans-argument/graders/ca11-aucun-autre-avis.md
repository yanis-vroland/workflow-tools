---
type: regex
target: { source: file, path: "docs/wf/montee-version.md" }
pattern: '\bCVE-(?!2024-29041\b)\d{4}-\d+|\bGHSA-(?!rv95-896h-c2vc\b)[a-z0-9]{4}-|\bS(?:[024-9]|1\d)\b'
match: not_contains
---

CA11 : le livrable ne cite aucun avis de sécurité ni identifiant `Sn` absent de la section « Dépendances vulnérables » du livrable de sécurité (seuls S3, CVE-2024-29041 et GHSA-rv95-896h-c2vc y figurent ; S1 est vérifié par ca11-s1-non-cite) : l'outil ne recherche pas lui-même les vulnérabilités.
