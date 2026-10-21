---
type: llm
focus: last_message
---

007-CA17. Un compte rendu `2026-10-07-point-hebdomadaire.md` existe déjà, tiré des notes `point-hebdo-equipe-nord.md` ; l'outil est lancé sur `point-hebdo-equipe-sud.md`, réunion du même jour au même objet.

Le dernier message signale le compte rendu existant et demande à l'utilisateur s'il s'agit d'une relance (mise à jour du compte rendu existant) ou d'une nouvelle réunion (nouveau compte rendu). Il n'annonce aucun compte rendu écrit ou mis à jour.

Échoue si la question n'est pas posée, si une seule des deux possibilités est proposée, ou si un compte rendu est annoncé comme produit.
