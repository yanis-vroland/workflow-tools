#!/usr/bin/env bash
# Spec 012, CA16 et CA18 : portail client FieldOps fictif en TypeScript (Vite et
# React), sans aucun framework de test ni fichier de test, et hors dépôt git
# (aucun git init). Contient un module à branches conditionnelles
# (src/quote.ts), un module sans branche (src/format.ts) et un fichier de types
# seuls (src/types.ts).
set -euo pipefail

if [ -n "$(ls -A .)" ]; then
  echo "Le répertoire de travail de l'eval devrait être vide." >&2
  exit 1
fi

mkdir -p src

cat >package.json <<'JSON'
{
  "name": "fieldops-portail",
  "version": "0.4.0",
  "private": true,
  "description": "Portail client : demande de devis d'intervention.",
  "scripts": {
    "dev": "vite",
    "build": "tsc && vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.3.1",
    "typescript": "^5.5.4",
    "vite": "^5.4.2"
  }
}
JSON

cat >tsconfig.json <<'JSON'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "react-jsx",
    "strict": true
  },
  "include": ["src"]
}
JSON

cat >vite.config.ts <<'TS'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
});
TS

cat >src/types.ts <<'TS'
// Types du portail client

export interface QuoteRequest {
  hours: number;
  hourlyRate: number;
  urgent: boolean;
}

export type QuoteStatus = "draft" | "sent" | "accepted";
TS

cat >src/quote.ts <<'TS'
import { QuoteRequest } from "./types";

// Estimation du devis affiché au client avant envoi de sa demande

export const URGENT_SURCHARGE = 1.5;

export function estimateQuote(request: QuoteRequest): number {
  if (request.hours <= 0 || request.hourlyRate < 0) {
    throw new Error("Demande de devis invalide");
  }
  const base = request.hours * request.hourlyRate;
  return request.urgent ? base * URGENT_SURCHARGE : base;
}
TS

cat >src/format.ts <<'TS'
// Mise en forme des montants pour l'affichage

export function formatEuros(amount: number): string {
  return `${amount.toFixed(2)} €`;
}
TS

cat >src/main.tsx <<'TSX'
import { createRoot } from "react-dom/client";
import { estimateQuote } from "./quote";
import { formatEuros } from "./format";

function App() {
  const total = estimateQuote({ hours: 2, hourlyRate: 60, urgent: false });
  return <p>Estimation : {formatEuros(total)}</p>;
}

createRoot(document.getElementById("root")!).render(<App />);
TSX
