---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*Secrets et configuration[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?=(?:(?!\n###? )[\s\S])*?middleware/auth\.ts[^\n]{0,15}\b6\b)(?=(?:(?!\n###? )[\s\S])*?\n- Statut : à vérifier)(?=(?:(?!\n###? )[\s\S])*?\n- Description : [^\n]*JWT_SECRET)'
match: contains
---

CA11 et CA14 : la valeur littérale de repli du secret JWT (`src/api/middleware/auth.ts`, ligne 6)
n'est utilisée que si la variable d'environnement `JWT_SECRET` est absente, ce que l'outil ne peut
pas lire : le constat est « à vérifier » et sa description nomme la variable. Remplace le juge llm
ca11-a-verifier-nomme-l-element-manquant (série r7 : 3 votes FAIL, à raison : le constat était
« confirmé »).
