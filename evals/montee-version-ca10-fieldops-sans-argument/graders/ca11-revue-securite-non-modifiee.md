---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '^(?=[\s\S]*Outil : wf-revue-securite · Date : 2026-10-05 · Commit : 2fc99c0\n)(?=[\s\S]*\n- \*\*S3\*\* : application web \(racine\), `express`, npm, version installée 4\.18\.2 \(`package-lock\.json`\), directe\. Avis CVE-2024-29041 \(GHSA-rv95-896h-c2vc\), sévérité publiée : moyenne\. Première version corrigée : 4\.19\.2\.\n)(?=[\s\S]*\n- \*\*S1\*\* : élevé, injection\.)'
match: contains
---

CA11 : le livrable `docs/wf/revue-securite.md` n'est jamais modifié : son en-tête et ses entrées S3 et S1 sont intacts (complète `ca01-aucune-ecriture-hors-livrable` et `ca01-aucune-edition-hors-livrable`, qui interdisent Write et Edit sur tout autre fichier).
