---
type: llm
focus: trace
---

004-CA15. Dans la trace, l'outil lit `brief-fieldops.md` et `notes-appel.md` (outil Read ou commande équivalente), et tente d'accéder à `compte-rendu-visio.md`, alors qu'aucun argument n'a été passé à la commande. Il ne s'arrête pas après l'échec sur `compte-rendu-visio.md` et termine en écrivant `docs/wf/cadrage-besoin.md`.

Échoue si l'une de ces sources n'est pas lue ou si l'outil s'interrompt sans mettre à jour le livrable.
