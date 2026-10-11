---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA20. La source `brief-en.md` est rédigée en anglais.

- Tout le texte rédigé par l'outil (synthèse, libellés des besoins, contraintes, hypothèses, questions, points non déterminés) est en français.
- Les citations de la source (ex. « The app must be fast », « Invoicing is not in scope ») restent en anglais, telles qu'écrites dans la source, et ne sont pas présentées comme traduites mot pour mot à la place de l'original.

Échoue si une partie rédigée est en anglais hors citation, ou si une citation est traduite.
