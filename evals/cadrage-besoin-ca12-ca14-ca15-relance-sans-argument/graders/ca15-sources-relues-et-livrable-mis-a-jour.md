---
type: llm
focus: { source: file, path: "docs/wf/cadrage-besoin.md" }
---

004-CA15. L'outil, relancé sans argument, relit les sources listées dans l'en-tête du livrable précédent (`brief-fieldops.md`, `notes-appel.md`, `compte-rendu-visio.md`, cette dernière introuvable) et met à jour le livrable.

- La date de l'en-tête n'est plus 2026-09-25.
- L'en-tête liste toujours `brief-fieldops.md` et `notes-appel.md`.
- Des éléments présents dans ces sources mais absents du livrable précédent y figurent désormais, par exemple l'historique des interventions par client et par équipement (brief) ou la prise de photos avant et après intervention (notes d'appel).
- Le livrable signale que `compte-rendu-visio.md` est introuvable, sans inventer son contenu.

Échoue si l'un de ces points est faux.
