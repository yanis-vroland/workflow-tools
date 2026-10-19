---
type: llm
focus: { source: file, path: "docs/wf/montee-version.md" }
---

CA10. L'outil a été lancé sans argument. Les écarts sont indiqués dans « Inventaire des versions ».

PASS si « Cibles retenues » respecte toutes ces règles :
1. Les dépendances dont l'écart est mineur ou correctif sont regroupées dans un lot unique (une seule cible), s'il en existe.
2. Chaque dépendance dont l'écart est majeur fait l'objet de sa propre cible (une cible par dépendance en écart majeur ; `react` et `react-dom` peuvent être deux cibles distinctes ou une cible commune si l'une entraîne l'autre).
3. Aucune dépendance « à jour » n'est une cible.
4. L'environnement d'exécution (Node.js) et le SDK (Flutter) ont chacun une cible s'ils ne sont pas à la dernière version LTS ou stable ; si cette dernière version n'a pas pu être établie, l'absence de cible est justifiée et reprise dans « Points non déterminés ».
5. Une cible placée en tête parce qu'elle corrige une entrée du livrable de sécurité (identifiant `S3`) est acceptée.

FAIL si les écarts mineurs et correctifs sont répartis en plusieurs cibles, si une dépendance en écart majeur n'a pas de cible, ou si une dépendance à jour est ciblée.
