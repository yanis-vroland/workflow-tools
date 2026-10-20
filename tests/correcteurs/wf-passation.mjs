#!/usr/bin/env node
// Vérifie les correcteurs des evals de wf-passation (evals/passation-*/), sans modèle.
//
// - Chaque motif (`pattern` des correcteurs regex, `input_match` des correcteurs
//   tool_used) est compilé comme le fait `claude plugin eval` : un motif
//   invalide n'apparaîtrait sinon qu'à la notation, et un `tool_used` `max: 0`
//   sans appel de l'outil ne serait jamais compilé.
// - La liste blanche Bash (`ca01-commandes-autorisees`) est vérifiée sur les
//   commandes prescrites par la skill et sur des commandes interdites.
// - Les correcteurs regex de `passation-fieldops` sont vérifiés sur un livrable
//   conforme (tous doivent réussir) et sur des livrables fautifs (le correcteur
//   visé doit échouer).
// - Les correcteurs de conservation de `passation-ca15-relance` doivent échouer
//   sur le dossier déposé par le scaffold : sinon ils réussiraient sans relance.
//
// Usage : node tests/correcteurs/wf-passation.mjs

import { readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");
let failures = 0;
const fail = (msg) => {
  console.log(`ÉCHEC  correcteurs wf-passation : ${msg}`);
  failures++;
};

// Clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function grader(path) {
  const text = readFileSync(path, "utf8");
  const front = text.split(/^---$/m)[1] ?? "";
  const fields = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    if (value.startsWith('"') && value.endsWith('"')) value = value.slice(1, -1);
    fields[m[1]] = value;
  }
  return fields;
}

// Résultat d'un correcteur regex sur un texte : true si le correcteur réussit
function passes(g, text) {
  const re = new RegExp(g.pattern, (g.flags ?? "") + "g");
  const n = (text.match(re) ?? []).length;
  if (g.match === "contains") return n > 0;
  if (g.match === "not_contains") return n === 0;
  if (g.match?.startsWith("count:")) return n === Number(g.match.slice(6));
  throw new Error(`match inconnu : ${g.match}`);
}

// --- Compilation de tous les motifs -------------------------------------------------

const cases = readdirSync(evals).filter((d) => d.startsWith("passation-"));
if (cases.length === 0) fail("aucun cas evals/passation-*");
const graders = {};
for (const c of cases) {
  graders[c] = {};
  for (const f of readdirSync(join(evals, c, "graders"))) {
    const g = grader(join(evals, c, "graders", f));
    graders[c][f.replace(/\.md$/, "")] = g;
    try {
      if (g.type === "regex") new RegExp(g.pattern, g.flags ?? "");
      if (g.type === "tool_used" && g.input_match) new RegExp(g.input_match);
    } catch (e) {
      fail(`${c}/${f} : motif invalide (${e.message})`);
    }
  }
}

// --- Liste blanche Bash -------------------------------------------------------------

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const allowed = [
  "git rev-parse --short HEAD",
  "git status --porcelain",
  "date +%F",
  "git symbolic-ref refs/remotes/origin/HEAD",
  "git show-ref --verify refs/heads/main",
  "git show-ref --verify refs/heads/master",
  "git branch -a --no-merged=origin/main",
  "git branch -a --no-merged=main",
  "git rev-list --count --end-of-options origin/main..remotes/origin/feat/x-y_1.2",
  "git log -1 --format=%cs --end-of-options remotes/origin/feat/x",
];
const forbidden = [
  "git fetch",
  "git pull",
  "git ls-remote origin",
  "git log -1 --format=%cs feat/x && npm test",
  "git rev-list --count main..x; rm a",
  "git log --format=%an",
  "git log -1 --format=%cs $(reboot)",
  "git log -1 --format=%cs `reboot`",
  'git log -1 --format=%cs "feat/x"',
  "git branch -a --no-merged main | head",
  "git status --porcelain > f",
  "npm test",
  "mkdir -p docs/wf",
  "cat README.md",
  // Argument pris pour une option (nom de branche commençant par « - »)
  "git log -1 --format=%cs --output=docs/x",
  "git log -1 --format=%cs --end-of-options --output=pwned.txt",
  "git branch -a --no-merged=--output=x",
  // Formes sans --end-of-options (ou sans « = ») : refusées
  "git log -1 --format=%cs feat/x",
  "git rev-list --count main..feat/x",
  "git branch -a --no-merged main",
  "git branch -a --no-merged --contains",
  "git rev-list --count main..--all",
  "git rev-list --count --all..main",
];
for (const c of cases) {
  const g = graders[c]["ca01-commandes-autorisees"];
  if (!g) {
    fail(`${c} : correcteur ca01-commandes-autorisees absent`);
    continue;
  }
  const re = new RegExp(g.input_match);
  for (const cmd of allowed) if (re.test(bash(cmd))) fail(`${c} : commande autorisée refusée : ${cmd}`);
  for (const cmd of forbidden) if (!re.test(bash(cmd))) fail(`${c} : commande interdite acceptée : ${cmd}`);
}

// --- passation-fieldops : livrable conforme et livrables fautifs --------------------

const good = `# Dossier de passation de FieldOps

Outil : wf-passation · Date : 2026-10-19 · Commit : 2fc99c0

Ce dossier a été établi par lecture des fichiers du projet, sans exécution.

## Synthèse

- Périmètre transmis : API et back-office web (racine), application mobile (\`mobile/\`).
- Commit de référence : \`2fc99c0\`.
- Checklist de passation : 6 lignes, dont 6 « à faire ».
- Interlocuteurs :
  - Responsable du projet côté client : à compléter
  - Prestataire sortant : à compléter
  - Repreneur : à compléter

## Documentation de référence

- [README.md](../../README.md)
- [mobile/README.md](../../mobile/README.md)
- Aucun livrable de \`wf-doc-projet\` : lancer \`/wf-doc-projet\`.

## Environnements et déploiement

### API et back-office web (racine)

- **recette** : déclencheur : push sur \`main\` (\`.github/workflows/deploy.yml\`).
  1. \`docker push <registre>/fieldops:recette\` (\`.github/workflows/deploy.yml\` l. 31)
  2. \`curl -fsS -X POST https://<serveur>/hooks/fieldops-recette\` (\`.github/workflows/deploy.yml\` l. 33)
- **production** : déclencheur : tag \`v*\`.

### Application mobile (\`mobile/\`)

procédure de déploiement non trouvée dans le dépôt

## Services tiers et accès

### API et back-office web (racine)

- **Service de cartographie** : \`src/services/mapClient.ts\` · titulaire du compte : à compléter
- **Service d'e-mail** : \`src/services/mailer.ts\` · titulaire du compte : à compléter
- **Service de paiement** : \`src/services/payment.ts\` · titulaire du compte : à compléter

### Application mobile (\`mobile/\`)

- Aucun service tiers identifié.

## Secrets à transmettre

Valeurs à transmettre par un canal sécurisé, hors de ce document.

| Secret | Utilisé pour | Référencé dans | Comment l'obtenir |
|---|---|---|---|
| \`REGISTRY_TOKEN\` | registre | \`.github/workflows/deploy.yml\` | à compléter |
| \`DEPLOY_TOKEN\` | webhook | \`.github/workflows/deploy.yml\` | à compléter |
| \`PRODUCTION_DATABASE_URL\` | purge | \`.github/workflows/purge.yml\` | à compléter |
| \`JWT_SECRET\` | jetons | \`.env.example\` | à compléter |
| \`PAYMENT_WEBHOOK_SECRET\` | à compléter | \`.env.example\` | à compléter |

## Travaux en cours

Branche principale : \`main\`. État des branches distantes : celui de la dernière récupération faite sur ce poste.

| Branche | Dernier commit | Commits d'avance |
|---|---|---|
| \`feat/export-pdf\` | 2026-09-30 | 3 |

Modifications non commitées : aucune.

## Points d'attention

15 marqueurs au total.

- \`README.md\` indique \`npm run start:dev\`, absent de \`package.json\`.
- \`.github/workflows/deploy.yml\` l. 29, 30, 31, 44, 45, 46 : registre d'images (\`<registre>\`) : à paramétrer au redéploiement.
- \`.github/workflows/deploy.yml\` l. 33, 48 : webhook (\`<serveur>\`) : à paramétrer au redéploiement.

## Checklist de passation

| Action | Source | Statut |
|---|---|---|
| Transférer l'accès au service de paiement | \`src/services/payment.ts\` | à faire |
| Transmettre le secret \`REGISTRY_TOKEN\` | \`.github/workflows/deploy.yml\` | à faire |
| Transmettre le secret \`PRODUCTION_DATABASE_URL\` | \`.github/workflows/purge.yml\` | à faire |
| Transférer les droits sur le dépôt de code | dépôt git | à faire |
| Fusionner, abandonner ou transmettre la branche \`feat/export-pdf\` | git | à faire |

## Points non déterminés

- Aucun.
`;

const fieldops = graders["passation-fieldops"] ?? {};
let checked = 0;
for (const [name, g] of Object.entries(fieldops)) {
  if (g.type !== "regex" || !g.target?.includes("passation.md")) continue;
  checked++;
  if (!passes(g, good)) fail(`passation-fieldops/${name} échoue sur un livrable conforme`);
}
if (checked < 40) fail(`passation-fieldops : ${checked} correcteurs regex vérifiés, au moins 40 attendus`);

// Variantes conformes : paramètre qui remplace aussi le schéma de l'adresse
const variants = [
  ["ca23-webhook-parametre", good.replace("https://<serveur>/hooks", "<serveur-de-déploiement>/hooks")],
];
for (const [name, text] of variants) {
  const g = fieldops[name];
  if (!g) fail(`passation-fieldops/${name} absent`);
  else if (!passes(g, text)) fail(`passation-fieldops/${name} échoue sur une variante conforme`);
}

// Chaque mutation doit faire échouer le correcteur nommé
const mutations = [
  ["ca23-aucune-adresse-recopiee", good.replace("<registre>/fieldops:recette", "registry.example.invalid/fieldops:recette")],
  ["ca23-exclusions-non-signalees", good.replace("## Checklist", "- `vite.config.ts` l. 10 : API locale (`<api>`) : à paramétrer au redéploiement.\n\n## Checklist")],
  ["ca23-exclusions-non-signalees", good.replace("## Checklist", "- `docker-compose.yml` l. 9 : base `db` : à paramétrer au redéploiement.\n\n## Checklist")],
  ["ca23-webhook-signale", good.replace("l. 33, 48 : webhook (`<serveur>`) : à paramétrer au redéploiement.", "webhook.")],
  ["ca23-webhook-parametre", good.replace("https://<serveur>/hooks", "https://hooks")],
  ["ca05-purge-non-deploiement", good.replace("- **production**", "- **purge** : `npx tsx src/jobs/purge-closed-interventions.ts`\n- **production**")],
  ["ca08-production-database-url", good.replace("| `PRODUCTION_DATABASE_URL` | purge | `.github/workflows/purge.yml` | à compléter |\n", "")],
  ["ca08-date-expiration-non-secret", good.replace("| `JWT_SECRET`", "| `MAP_API_KEY_EXPIRES_AT` | à compléter | `.env.example` | à compléter |\n| `JWT_SECRET`")],
  ["ca08-aucune-valeur", good.replace("15 marqueurs au total.", "15 marqueurs au total. Clé valable jusqu'au 2027-03-31.")],
  ["ca14-ligne-production-database-url", good.replace("| Transmettre le secret `PRODUCTION_DATABASE_URL` | `.github/workflows/purge.yml` | à faire |\n", "")],
  ["ca17-interlocuteurs-a-completer", good.replace(/  - (Responsable du projet côté client|Prestataire sortant) : à compléter\n/g, "")],
  ["ca17-interlocuteurs-a-completer", good.replace(/ : à compléter\n  - Prestataire sortant : à compléter/, " : la direction technique\n  - Prestataire sortant : une agence")],
  ["ca21-arbre-propre-sans-mention", good.replace("Commit : 2fc99c0\n", "Commit : 2fc99c0 · modifications non commitées\n")],
];
for (const [name, text] of mutations) {
  const g = fieldops[name];
  if (!g) fail(`passation-fieldops/${name} absent`);
  else if (passes(g, text)) fail(`passation-fieldops/${name} réussit sur un livrable fautif`);
}

// --- passation-ca15-relance : le dossier déposé ne satisfait aucune conservation ----

const scaffold = readFileSync(join(evals, "passation-ca15-relance", "scaffold.sh"), "utf8");
const old = /cat >docs\/wf\/passation\.md <<'MD'\n([\s\S]*?)\nMD\n/.exec(scaffold)?.[1];
if (!old) fail("passation-ca15-relance : dossier déposé introuvable dans scaffold.sh");
else {
  let n = 0;
  for (const [name, g] of Object.entries(graders["passation-ca15-relance"] ?? {})) {
    if (g.type !== "regex" || !/conserve|mis-a-jour|a-faire/.test(name)) continue;
    n++;
    if (passes(g, "\n" + old)) fail(`passation-ca15-relance/${name} réussit déjà sur le dossier déposé (faux vert)`);
  }
  if (n < 8) fail(`passation-ca15-relance : ${n} correcteurs de conservation vérifiés, au moins 8 attendus`);
}

if (failures === 0) console.log("OK     correcteurs wf-passation");
process.exit(failures ? 1 : 0);
