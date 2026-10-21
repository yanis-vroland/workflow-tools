---
type: regex
target: { source: file, path: "docs/wf/revue-securite.md" }
pattern: '\n### S\d+(?=(?:(?!\n###? )[\s\S])*?auth_service\.dart[^\n]{0,15}\b2[1-4]\b)(?=(?:(?!\n###? )[\s\S])*?stockage non s[ée]curis[ée])'
flags: 'i'
match: contains
---

CA15 : le jeton stocké avec `shared_preferences` (`mobile/lib/services/auth_service.dart`,
ligne 24, ou l'appel qui l'obtient, lignes 21 à 24) donne un constat de catégorie « stockage non
sécurisé » avec le fichier et la ligne.
