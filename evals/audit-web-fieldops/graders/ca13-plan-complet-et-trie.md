---
type: llm
focus: { source: file, path: "docs/wf/audit-web.md" }
---

CA13 : la section « Plan d'action » reprend tous les constats du document par leur identifiant (W1, W2…),
triés par niveau : tous les « élevé », puis tous les « moyen », puis tous les « faible ».

PASS si chaque identifiant de constat présent dans les sections Performance, Accessibilité, Référencement et
Bonnes pratiques apparaît dans « Plan d'action », qu'aucun identifiant n'y apparaît sans constat
correspondant, que l'ordre des niveaux est respecté, et qu'aucune durée ou charge (jours, heures) n'est
estimée. FAIL sinon.
