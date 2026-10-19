---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA11. Le projet contient `docs/wf/revue-securite.md`, dont la section « Dépendances vulnérables » cite `S3` : `express` 4.18.2, première version corrigée 4.19.2. `S1` y est un constat dans le code, pas une dépendance.

PASS si toutes ces conditions sont réunies :
1. La cible qui monte `express` à une version supérieure ou égale à 4.19.2 cite `S3` et est la première de « Cibles retenues ».
2. La première étape de « Plan de montée » porte sur cette montée d'`express` et cite `S3`.
3. Le livrable ne présente pas `S1` comme une dépendance à monter, et n'ajoute aucun avis de sécurité (CVE, GHSA) qui ne figure pas dans le livrable de sécurité.

FAIL sinon.
