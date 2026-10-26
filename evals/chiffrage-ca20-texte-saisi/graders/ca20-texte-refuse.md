---
type: llm
focus: last_message
---

005-CA20. La commande a reçu un texte (« une application de prise de rendez-vous en ligne pour un garage automobile… ») au lieu d'un chemin de fichier.

Le dernier message indique que le texte saisi dans la commande n'est pas accepté comme entrée, qu'il faut passer un chemin de fichier de besoin (ou lancer `/wf-cadrage-besoin` puis `/wf-chiffrage` sans argument), et qu'aucun livrable n'a été écrit. Il ne contient aucune estimation, ni du garage ni du cadrage présent dans le projet.

Échoue si le texte est chiffré, si le message annonce un livrable, ou si le refus du texte saisi n'est pas dit.
