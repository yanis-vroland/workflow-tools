---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n## [^\n]*(?:Constats dans le code|Secrets et configuration)[^\n]*\n(?:(?!\n## )[\s\S])*?\n### S\d+(?!(?=(?:(?!\n###? )[\s\S])*?\n- Application : \S)(?=(?:(?!\n###? )[\s\S])*?\n- Niveau : (?:élevé|moyen|faible)\s)(?=(?:(?!\n###? )[\s\S])*?\n- Catégorie : [^\n]*\((?:A(?:0[1-9]|10)|M(?:[1-9]|10)):20\d\d\b)(?=(?:(?!\n###? )[\s\S])*?\n- Emplacement : [^\n]*(?::\d+|\.env[\w.-]*`))(?=(?:(?!\n###? )[\s\S])*?\n- Description : \S)(?=(?:(?!\n###? )[\s\S])*?\n- Recommandation : \S)(?=(?:(?!\n###? )[\s\S])*?\n- Statut : (?:confirmé|à vérifier)\s))'
match: not_contains
---

CA9 et CA24 : chaque entrée de « Constats dans le code » et de « Secrets et configuration » porte
son application, un niveau (élevé, moyen, faible), une catégorie suivie de sa référence OWASP
(Ann:AAAA ou Mn:AAAA), un emplacement `chemin:ligne` (ou le chemin d'un fichier d'environnement
suivi), une description, une recommandation et un statut « confirmé » ou « à vérifier ».
Remplace un juge llm bruité sur ce long livrable (série r7 : 3 votes FAIL sur un livrable conforme).
