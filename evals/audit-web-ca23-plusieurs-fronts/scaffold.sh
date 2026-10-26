#!/usr/bin/env bash
# Spec 011, CA23 (plusieurs fronts web JS/TS) et CA22 (front d'une stack non
# couverte). Part de FieldOps web seul (back-office React dans src/web/), puis
# ajoute, dans un commit déterministe :
#   - portail/ : un second front, Next.js (app router), avec un <Image> sans alt
#     (CA6), un <textarea> sans libellé (CA7), deux champs correctement libellés
#     (aria-label, label for : aucun constat attendu), un titre défini par
#     `metadata` mais aucune meta description (CA9 : constat de référencement
#     seul, pas de RGAA 8.5) ;
#   - legacy-php/ : d'anciens gabarits PHP avec <html> sans lang et <img> sans
#     alt, stack non couverte en v1 : aucun constat attendu (CA22).
set -euo pipefail

repo="$(cd "$(dirname "$0")/../.." && pwd)"
bash "$repo/tests/fixtures/build-fieldops-web.sh" "$PWD"

mkdir -p portail/app/contact portail/public legacy-php/templates

cat >portail/package.json <<'JSON'
{
  "name": "fieldops-portail",
  "version": "0.3.0",
  "private": true,
  "description": "Portail client : suivi des demandes d'intervention.",
  "scripts": {
    "dev": "next dev -p 4000",
    "build": "next build",
    "start": "next start -p 4000"
  },
  "dependencies": {
    "next": "^14.2.5",
    "react": "^18.3.1",
    "react-dom": "^18.3.1"
  },
  "devDependencies": {
    "typescript": "^5.4.5"
  }
}
JSON

cat >portail/app/layout.tsx <<'TSX'
import type { Metadata } from "next";
import type { ReactNode } from "react";

export const metadata: Metadata = {
  title: "Portail client FieldOps",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="fr">
      <body>{children}</body>
    </html>
  );
}
TSX

cat >portail/app/page.tsx <<'TSX'
import Image from "next/image";
import Link from "next/link";

export default function HomePage() {
  return (
    <main>
      <h1>Vos demandes d'intervention</h1>
      <Image src="/accueil.svg" width={640} height={240} />
      <p>Suivez l'avancement des interventions planifiées sur vos sites.</p>
      <Link href="/contact">Nous contacter</Link>
    </main>
  );
}
TSX

cat >portail/app/contact/page.tsx <<'TSX'
export default function ContactPage() {
  return (
    <main>
      <h1>Nous contacter</h1>
      <form method="post" action="/api/contact">
        <label htmlFor="name">Nom</label>
        <input id="name" name="name" />
        <input type="email" name="email" aria-label="Adresse e-mail" />
        <textarea name="message" rows={6} />
        <button type="submit">Envoyer</button>
      </form>
    </main>
  );
}
TSX

cat >portail/public/accueil.svg <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="640" height="240" viewBox="0 0 640 240"><rect width="640" height="240" fill="#1d4ed8"/></svg>
SVG

cat >legacy-php/composer.json <<'JSON'
{
  "name": "fieldops/legacy-extranet",
  "description": "Ancien extranet client, en cours de remplacement par le portail.",
  "require": { "php": ">=7.4" }
}
JSON

cat >legacy-php/templates/accueil.php <<'PHP'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
  </head>
  <body>
    <img src="/images/bandeau-extranet.jpg" />
    <?php foreach ($demandes as $demande): ?>
      <p><?= htmlspecialchars($demande['adresse']) ?></p>
    <?php endforeach; ?>
    <input name="recherche" placeholder="Rechercher" />
  </body>
</html>
PHP

export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null TZ=UTC
export GIT_AUTHOR_NAME="Théo Vasseur" GIT_AUTHOR_EMAIL="theo.vasseur@example.invalid"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME" GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
export GIT_AUTHOR_DATE="2026-10-03T10:00:00Z" GIT_COMMITTER_DATE="2026-10-03T10:00:00Z"
git -c core.hooksPath=/dev/null -c commit.gpgsign=false add portail legacy-php
git -c core.hooksPath=/dev/null -c commit.gpgsign=false commit -q -m "feat(portail): portail client Next.js et reprise de l'ancien extranet"
