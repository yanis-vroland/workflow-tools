#!/usr/bin/env bash
# Petit projet TypeScript fictif, hors git, qui cumule des cas limites de la
# spec 003 :
#   - CA3  : aucune version de Node.js fixée (ni .nvmrc, ni engines, ni Dockerfile) ;
#   - CA5  : aucune commande de test (ni script test, ni fichier de test) ;
#   - CA10 : aucune convention de contribution (ni CONTRIBUTING.md, ni lint,
#            ni format, ni hook, ni CI, ni modèle de PR) ;
#   - CA11 : un terme métier, Ravel, dont aucun fichier n'établit le sens, et un
#            terme, Tariff, défini par un commentaire ;
#   - CA15 : projet hors git ;
#   - CA19 : aucune commande de lancement (seulement un script build).
set -euo pipefail

mkdir -p src

cat >README.md <<'MD'
# FieldOps Tarifs

Calcul des tarifs des interventions FieldOps.
MD

cat >package.json <<'JSON'
{
  "name": "fieldops-tarifs",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "build": "tsc -p tsconfig.json"
  },
  "devDependencies": {
    "typescript": "^5.3.2"
  }
}
JSON

cat >tsconfig.json <<'JSON'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "outDir": "dist",
    "strict": true
  },
  "include": ["src"]
}
JSON

cat >src/models.ts <<'TS'
/** Tarif horaire d'une catégorie d'intervention, en centimes. */
export interface Tariff {
  id: number;
  category: string;
  hourlyRateCents: number;
}

export interface Ravel {
  id: number;
  code: string;
  tariffId: number;
}
TS

cat >src/pricing.ts <<'TS'
import { Ravel, Tariff } from "./models";

export function priceOf(ravel: Ravel, tariffs: Tariff[], hours: number): number {
  const tariff = tariffs.find((t) => t.id === ravel.tariffId);
  if (!tariff) {
    throw new Error(`Tarif introuvable pour ${ravel.code}`);
  }
  return Math.round(tariff.hourlyRateCents * hours);
}
TS

cat >src/index.ts <<'TS'
export * from "./models";
export * from "./pricing";
TS
