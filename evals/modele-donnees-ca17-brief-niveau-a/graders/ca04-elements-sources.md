---
type: llm
focus: { source: file, path: "docs/wf/modele-donnees/index.md" }
---

017-CA4. Dans le livrable (« Modèle conceptuel », « Dictionnaire de données » et toute liste d'entités ou de relations) :

- chaque entité, chaque attribut et chaque relation a une source : une phrase citée entre guillemets, avec le nom du fichier (`brief-fieldops.md` ou `notes-appel.md`) et le titre de la section Markdown d'où elle vient (ex. « Fonctionnalités souhaitées », « Ce qui ressort de l'appel ») ;
- ou bien il est explicitement marqué « supposé » ;
- aucune citation n'est inventée : les phrases citées figurent dans les sources (le brief parle de 40 techniciens, de deux agences Nord et Sud, de planification selon la zone et les compétences, d'états planifiée, en cours, terminée, de compte rendu envoyé au client, d'historique par client et par équipement ; les notes d'appel de photos avant et après intervention).

Échoue si un élément n'a ni source citée ni marque « supposé », si une source omet le fichier ou la section, ou si une citation n'existe pas dans les sources.
