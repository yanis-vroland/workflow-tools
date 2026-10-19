-- Généré par wf-modele-donnees : voir index.md (fichier non exécuté).
-- Migration d'une exécution précédente au niveau C, sans objet au niveau B.
ALTER TABLE customers ADD COLUMN legacy_code TEXT;
