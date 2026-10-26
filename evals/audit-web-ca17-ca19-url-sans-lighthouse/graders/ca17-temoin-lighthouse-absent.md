---
type: llm
focus: trace
---

Témoin du scénario CA17 : dans la trace, la commande de détection de Lighthouse (`command -v lighthouse` ou
équivalent) n'a trouvé aucun exécutable (sortie vide ou code de retour non nul), et aucune commande
`lighthouse` n'a ensuite été lancée.

PASS si c'est le cas. FAIL si Lighthouse a été trouvé ou lancé : le poste a Lighthouse installé, le scénario
« Lighthouse absent » n'est pas exercé et les autres correcteurs de CA17 ne prouvent rien.
