#!/usr/bin/env bash
# Spec 011, CA20 : projet sans front web, API JS/TS seule (Express), hors git.
# Ni HTML, ni composant, ni gabarit : l'outil doit l'indiquer et n'écrire aucun
# livrable.
set -euo pipefail

mkdir -p src/routes

cat >package.json <<'JSON'
{
  "name": "inventaire-api",
  "version": "0.4.0",
  "private": true,
  "description": "API REST de suivi du stock de pièces détachées.",
  "scripts": {
    "dev": "tsx watch src/server.ts",
    "build": "tsc -p tsconfig.json",
    "start": "node dist/server.js"
  },
  "dependencies": {
    "express": "^4.19.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "tsx": "^4.7.0",
    "typescript": "^5.4.5"
  }
}
JSON

cat >tsconfig.json <<'JSON'
{
  "compilerOptions": { "target": "ES2022", "module": "commonjs", "outDir": "dist", "strict": true },
  "include": ["src"]
}
JSON

cat >src/server.ts <<'TS'
import express from "express";
import { partsRouter } from "./routes/parts";

const app = express();
app.use(express.json());
app.use("/api/parts", partsRouter);

app.listen(Number(process.env.PORT ?? 3000));
TS

cat >src/routes/parts.ts <<'TS'
import { Router } from "express";

type Part = { id: number; reference: string; quantity: number };

const parts: Part[] = [];

export const partsRouter = Router();

partsRouter.get("/", (_req, res) => {
  res.json(parts);
});

partsRouter.post("/", (req, res) => {
  const part: Part = { id: parts.length + 1, reference: req.body.reference, quantity: req.body.quantity };
  parts.push(part);
  res.status(201).json(part);
});
TS
