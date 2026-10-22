#!/usr/bin/env node
// Vérifie les correcteurs des evals de wf-montee-version (evals/montee-version-*/)
// sans modèle, sur le modèle de tests/correcteurs/wf-analyse-projet.mjs.
//
// 1. Chaque cas : case.yaml au schéma 1.1, modèle Sonnet, tags wf-montee-version,
//    spec-013 et exactement un de reseau / hors-reseau ; chaque correcteur nommé
//    d'après le critère qu'il vérifie (caNN-, adr001- ou temoin-).
// 2. Chaque motif (pattern, input_match) compile comme le fait `claude plugin
//    eval` : new RegExp(input_match) sur l'entrée JSON de l'outil,
//    new RegExp(pattern, flags) sur le texte visé.
// 3. Exemples positifs et négatifs pour les correcteurs d'interdiction (Bash,
//    Grep), et livrables d'exemple : un livrable conforme doit réussir tous les
//    correcteurs regex de son cas, chaque livrable fautif doit en faire échouer
//    au moins le correcteur visé.
// 4. Les commandes prescrites par la skill (blocs ```bash de SKILL.md) ne
//    déclenchent aucun correcteur d'interdiction, et déclenchent les correcteurs
//    qui exigent l'interrogation des registres et du calendrier de fin de support.
//
// Usage : node tests/correcteurs/wf-montee-version.mjs

import { existsSync, readFileSync, readdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");
let failures = 0;
const ok = (msg) => console.log(`OK     ${msg}`);
const ko = (msg, details = []) => {
  failures++;
  console.log(`ÉCHEC  ${msg}`);
  for (const d of details) console.log(`         ${d}`);
};

// Clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function parse(path) {
  const text = readFileSync(path, "utf8");
  const front = text.split(/^---$/m)[1] ?? "";
  const fields = {};
  for (const line of front.split("\n")) {
    const m = /^(\w+):\s*(.*)$/.exec(line);
    if (!m) continue;
    let value = m[2].trim();
    if (value.startsWith("'") && value.endsWith("'")) value = value.slice(1, -1).replace(/''/g, "'");
    else if (value.startsWith('"') && value.endsWith('"')) value = value.slice(1, -1);
    fields[m[1]] = value;
  }
  return fields;
}

const cases = readdirSync(evals)
  .filter((d) => d.startsWith("montee-version-"))
  .sort();
if (cases.length === 0) {
  ko("aucun cas evals/montee-version-* trouvé");
  process.exit(1);
}

// --- 1 et 2 : structure des cas, compilation des motifs ----------------------------

const graders = {}; // "cas/fichier" -> { fields, re }
for (const c of cases) {
  const dir = join(evals, c);
  const errors = [];
  const yaml = existsSync(join(dir, "case.yaml")) ? readFileSync(join(dir, "case.yaml"), "utf8") : "";
  if (!yaml) errors.push("case.yaml absent");
  if (!/^schema_version: "1\.1"$/m.test(yaml)) errors.push('schema_version: "1.1" attendu');
  if (!/^\s+model: claude-sonnet-5-5$/m.test(yaml)) errors.push("execution.model: claude-sonnet-5-5 attendu");
  if (!new RegExp(`^name: ${c}$`, "m").test(yaml)) errors.push("name différent du nom du dossier");
  const tags = (/^tags:\s*\[(.*)\]/m.exec(yaml)?.[1] ?? "").split(",").map((t) => t.trim());
  if (!tags.includes("wf-montee-version") || !tags.includes("spec-013")) errors.push("tags wf-montee-version et spec-013 attendus");
  if (tags.filter((t) => t === "reseau" || t === "hors-reseau").length !== 1) errors.push("exactement un tag reseau ou hors-reseau attendu");
  const prompt = existsSync(join(dir, "prompt.md")) ? readFileSync(join(dir, "prompt.md"), "utf8") : "";
  if (!/^\/wf-montee-version(?: \S.*)?\n?$/.test(prompt)) errors.push("prompt.md doit lancer /wf-montee-version");
  if (!existsSync(join(dir, "scaffold.sh"))) errors.push("scaffold.sh absent");
  const files = existsSync(join(dir, "graders")) ? readdirSync(join(dir, "graders")).filter((f) => f.endsWith(".md")) : [];
  if (files.length === 0) errors.push("aucun correcteur");
  for (const f of files) {
    if (!/^(?:ca\d{2}|adr001|temoin)-[a-z0-9-]+\.md$/.test(f)) errors.push(`${f} : nom attendu caNN-…, adr001-… ou temoin-…`);
    const fields = parse(join(dir, "graders", f));
    if (!["regex", "file_exists", "tool_used", "llm"].includes(fields.type)) errors.push(`${f} : type ${fields.type} non permis`);
    if ("negate" in fields) errors.push(`${f} : clé negate non permise`);
    if (fields.type === "tool_used" && fields.tool === "Skill") errors.push(`${f} : tool_used Skill non permis`);
    if (fields.type === "tool_used" && fields.max === "0" && fields.min !== "0") errors.push(`${f} : max: 0 exige min: 0`);
    // Un interdit sur un outil non accordé passerait forcément sans rien mesurer
    const allowed = (/^\s+allowed_tools:\s*\[(.*)\]/m.exec(yaml)?.[1] ?? "").split(",").map((t) => t.trim());
    if (fields.type === "tool_used" && !allowed.includes(fields.tool)) errors.push(`${f} : outil ${fields.tool} absent des allowed_tools du cas`);
    let re = null;
    const source = fields.input_match ?? fields.pattern;
    if (source !== undefined) {
      try {
        re = new RegExp(source, fields.input_match !== undefined ? "" : (fields.flags ?? ""));
      } catch (error) {
        errors.push(`${f} : motif invalide (${error.message})`);
      }
    }
    graders[`${c}/${f}`] = { fields, re };
  }
  if (errors.length) ko(`${c} : structure du cas`, errors);
  else ok(`${c} : structure du cas et ${files.length} correcteurs compilés`);
}

// Verdict d'un correcteur regex ou tool_used sur un exemple (texte ou entrée JSON)
function passes({ fields, re }, sample) {
  if (fields.type === "tool_used") {
    const hit = re.test(sample);
    if (fields.max === "0") return !hit;
    return hit;
  }
  const match = fields.match ?? "contains";
  if (match === "contains") return re.test(sample);
  if (match === "not_contains") return !re.test(sample);
  const count = /^count:(\d+)$/.exec(match);
  if (count) return (sample.match(new RegExp(re.source, `${re.flags.replace("g", "")}g`)) ?? []).length === Number(count[1]);
  throw new Error(`match inconnu : ${match}`);
}

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const grep = (input) => JSON.stringify({ pattern: "TODO", ...input });
const webfetch = (url) => JSON.stringify({ url, prompt: "Ruptures" });

// check <libellé> <correcteur> <exemples qui réussissent> <exemples qui échouent>
function check(label, key, passing, failing) {
  const g = graders[key];
  if (!g?.re) {
    ko(`${label} : correcteur ${key} introuvable ou sans motif`);
    return;
  }
  const errors = [];
  for (const s of passing) if (!passes(g, s)) errors.push(`devrait réussir : ${JSON.stringify(s).slice(0, 300)}`);
  for (const s of failing) if (passes(g, s)) errors.push(`devrait échouer : ${JSON.stringify(s).slice(0, 300)}`);
  if (errors.length) ko(`${label} (${key})`, errors);
  else ok(`${label} (${key} : ${passing.length} réussites, ${failing.length} échecs attendus)`);
}

// --- 3a : correcteurs d'interdiction, communs à tous les cas ---------------------

const nominal = "montee-version-ca10-fieldops-sans-argument";
const interdits = {
  "ca20-ni-installation-ni-execution.md": {
    violations: [
      "npm install react@19.2.0",
      "npm i -D @types/react@19",
      "pnpm add react@19",
      "pnpm --filter @fieldops/web add react@19",
      "yarn add react@19",
      "cd mobile && flutter pub get",
      "flutter pub upgrade --major-versions",
      "flutter pub add http:^1.6.0",
      "fvm flutter test",
      "npm test",
      "npm run build",
      "npx vitest run",
      "env CI=1 npm ci",
    ],
    permis: ["git rev-parse --short HEAD", "git status --porcelain", "date +%F", 'grep -rn "ReactDOM.render" src'],
  },
  "ca20-ni-branche-ni-commit.md": {
    violations: ["git checkout -b montee-react", "git switch -c montee", "git branch montee-react", "git commit -m x", "git add package.json", "git stash"],
    permis: ["git rev-parse --short HEAD", "git status --porcelain", "git log -1 --format=%h"],
  },
  "ca01-aucune-modification-par-bash.md": {
    violations: ["echo x > package.json", "sed -i '' 's/17/19/' package.json", "cp package-lock.json /tmp/x", "rm pubspec.lock", "curl -sf https://x | tee mobile/pubspec.yaml"],
    permis: ["git status --porcelain 2>/dev/null", "date +%F"],
  },
  "ca01-curl-sans-ecriture.md": {
    violations: [
      "curl -o out.json https://registry.npmjs.org/react",
      "curl -sfo out.json https://registry.npmjs.org/react",
      "curl -sfO https://registry.npmjs.org/react/-/react-19.0.0.tgz",
      "curl --output out.json https://pub.dev/api/packages/http",
      "curl --remote-name https://x/y",
    ],
    permis: [
      "curl -sf --max-time 10 -w '\\n%{http_code}' https://registry.npmjs.org/react/latest",
      "curl -s -o /dev/null -w '%{http_code}' https://endoflife.date/api/nodejs.json",
      "curl -sf --location https://x",
      "curl -sf -H 'Accept: application/vnd.npm.install-v1+json' https://registry.npmjs.org/react",
    ],
  },
};
for (const [file, { violations, permis }] of Object.entries(interdits)) {
  check("interdiction", `${nominal}/${file}`, permis.map(bash), violations.map(bash));
}
check(
  "CA25 Bash",
  `${nominal}/ca25-fichier-env-non-lu-bash.md`,
  ["cat .env.example", "rg TODO --glob '!.env*'", 'grep -rn "process.env" src'].map(bash),
  ["cat .env", "grep KEY .env.local", "head -3 ./.env"].map(bash),
);
check(
  "CA25 Grep",
  `${nominal}/ca25-fichier-env-non-lu-grep.md`,
  [{ path: "/p/src", glob: "*.{ts,tsx}" }, { glob: "!.env*" }].map(grep),
  [{ path: "/p/.env" }, { glob: ".env*" }].map(grep),
);
check(
  "CA25 Read",
  `${nominal}/ca25-fichier-env-non-lu-read.md`,
  [JSON.stringify({ file_path: "/p/.env.example" }), JSON.stringify({ file_path: "/p/package.json" })],
  [JSON.stringify({ file_path: "/p/.env" }), JSON.stringify({ file_path: "/p/.env.local" })],
);
check(
  "CA1 Write",
  `${nominal}/ca01-aucune-ecriture-hors-livrable.md`,
  [JSON.stringify({ file_path: "/p/docs/wf/montee-version.md", content: "x" })],
  [JSON.stringify({ file_path: "/p/package.json", content: "x" }), JSON.stringify({ file_path: "/p/docs/wf/revue-securite.md", content: "x" })],
);
check(
  "CA11 aucune recherche de vulnérabilités (Bash)",
  `${nominal}/ca11-aucune-recherche-de-vulnerabilites-bash.md`,
  ["curl -sf https://registry.npmjs.org/express/latest", "curl -sf https://endoflife.date/api/nodejs.json"].map(bash),
  ["npm audit --json", "curl -s -d '{}' https://api.osv.dev/v1/query", "pnpm audit"].map(bash),
);
check(
  "CA11 aucune recherche de vulnérabilités (WebFetch)",
  `${nominal}/ca11-aucune-recherche-de-vulnerabilites-webfetch.md`,
  [webfetch("https://pub.dev/packages/http/changelog"), webfetch("https://react.dev/blog/2024/04/25/react-19-upgrade-guide")],
  [webfetch("https://osv.dev/vulnerability/GHSA-rv95-896h-c2vc"), webfetch("https://github.com/advisories/GHSA-rv95-896h-c2vc")],
);
check(
  "CA3 registre npm",
  `${nominal}/ca03-registre-npm-interroge.md`,
  ["curl -sf --max-time 10 https://registry.npmjs.org/react/latest"].map(bash),
  ["grep registry.npmjs.org package-lock.json", "cat package-lock.json"].map(bash),
);
check(
  "CA9 registre interrogé pour react",
  "montee-version-ca09-version-inexistante/ca09-registre-interroge.md",
  ["curl -sf https://registry.npmjs.org/react/99.0.0", "for p in 'react'; do curl -sf \"https://registry.npmjs.org/$p\"; done",
    "while read -r p v; do curl -s \"https://registry.npmjs.org/$p\"; done <<'WF_NOMS_7c1e'\nreact 99.0.0\nWF_NOMS_7c1e"].map(bash),
  ["curl -sf https://registry.npmjs.org/react-dom/latest", "grep react package-lock.json", "curl -sf https://pub.dev/api/packages/react",
    "while read -r p v; do curl -s \"https://registry.npmjs.org/$p\"; done <<'WF_NOMS_7c1e'\nreact-dom 19\n@types/react\nWF_NOMS_7c1e"].map(bash),
);
check(
  "CA14 métadonnées de react-dom",
  "montee-version-ca08-cible-react-dom/ca14-metadonnees-consultees.md",
  ["curl -sf https://registry.npmjs.org/react-dom/19.2.0", "for p in 'react-dom'; do curl -sf \"https://registry.npmjs.org/$p\"; done"].map(bash),
  ["curl -sf https://registry.npmjs.org/react/latest", "grep react-dom package-lock.json"].map(bash),
);
check(
  "CA3 registre pub.dev",
  `${nominal}/ca03-registre-pub-dev-interroge.md`,
  ['url="https://pub.dev/api/packages/$p"; curl -s "$url"', "curl -s https://pub.dev/api/packages/http"].map(bash),
  ["grep -n pub.dev mobile/pubspec.lock", "cat mobile/pubspec.lock", "curl -s https://pub.dev/packages/http/changelog"].map(bash),
);
check(
  "CA7 témoin d'échec réseau",
  "montee-version-ca07-registre-injoignable/ca07-temoin-echec-reseau.md",
  ['{"type":"tool_result","content":"npm react injoignable (curl 7)"}', "curl: (6) Could not resolve host", "npm react injoignable (HTTP 403)"],
  ['{"command":"*) echo \\"npm $p injoignable (curl $rc)\\" ;;"}', '{"command":"echo \\"npm $p injoignable (HTTP $code)\\""}', "registre injoignable : repli sur le lockfile"],
);

// --- 3b : livrables d'exemple -------------------------------------------------------

const section = (title, body) => `## ${title}\n\n${body.trim()}\n`;
const livrable = (header, parts) =>
  [
    "# Plan de montée de version de fieldops",
    "",
    header,
    "",
    "Plan établi par lecture des fichiers du projet et des sources publiques citées, sans installation ni exécution.",
    "",
    ...["Synthèse", "Inventaire des versions", "Cibles retenues", "Ruptures et impacts", "Plan de montée", "Vérifications", "Points non déterminés"].map((t) =>
      section(t, parts[t] ?? "Aucun."),
    ),
  ].join("\n");
const row = (name, constraint, installed, latest, gap, usage) => `| \`${name}\` | \`${constraint}\` | ${installed} | ${latest} | ${gap} | \`${usage}\` |`;
const table = (rows) => ["| Dépendance | Contrainte déclarée | Installée | Dernière publiée | Écart | Usage |", "|---|---|---|---|---|---|", ...rows].join("\n");

const webRows = [
  ["bcryptjs", "^2.4.3", "2.4.3", "3.0.2", "majeur", "dependencies"],
  ["cors", "^2.8.5", "2.8.5", "2.8.5", "à jour", "dependencies"],
  ["express", "^4.18.2", "4.18.2", "5.1.0", "majeur", "dependencies"],
  ["jsonwebtoken", "^9.0.2", "9.0.2", "9.0.2", "à jour", "dependencies"],
  ["pg", "^8.11.3", "8.11.3", "8.16.3", "mineur", "dependencies"],
  ["react", "^17.0.2", "17.0.2", "19.2.0", "majeur", "dependencies"],
  ["react-dom", "^17.0.2", "17.0.2", "19.2.0", "majeur", "dependencies"],
  ["@types/express", "^4.17.21", "4.17.21", "5.0.3", "majeur", "devDependencies"],
  ["@types/react", "^17.0.70", "17.0.70", "19.2.2", "majeur", "devDependencies"],
  ["@types/react-dom", "^17.0.23", "17.0.23", "19.2.1", "majeur", "devDependencies"],
  ["@vitejs/plugin-react", "^4.2.0", "4.2.0", "5.0.4", "majeur", "devDependencies"],
  ["eslint", "^8.54.0", "8.54.0", "9.37.0", "majeur", "devDependencies"],
  ["tsx", "^4.6.0", "4.6.0", "4.20.6", "mineur", "devDependencies"],
  ["typescript", "^5.3.2", "5.3.2", "5.9.3", "mineur", "devDependencies"],
  ["vite", "^5.0.4", "5.0.4", "7.1.9", "majeur", "devDependencies"],
  ["vitest", "^1.0.1", "1.0.1", "3.2.4", "majeur", "devDependencies"],
];
const mobileRows = [
  ["http", "^0.13.6", "0.13.6", "1.6.0", "majeur", "dependencies"],
  ["sqflite", "^2.3.0", "2.3.0", "2.4.2", "mineur", "dependencies"],
  ["path", "^1.8.3", "1.8.3", "1.9.1", "mineur", "dependencies"],
  ["shared_preferences", "^2.2.2", "2.2.2", "2.5.3", "mineur", "dependencies"],
  ["geolocator", "^9.0.2", "9.0.2", "14.0.2", "majeur", "dependencies"],
  ["image_picker", "^1.0.4", "1.0.4", "1.2.0", "mineur", "dependencies"],
  ["json_annotation", "^4.8.1", "4.8.1", "4.9.0", "mineur", "dependencies"],
  ["build_runner", "^2.4.6", "2.4.6", "2.9.0", "mineur", "dev_dependencies"],
  ["json_serializable", "^6.7.1", "6.7.1", "6.11.1", "mineur", "dev_dependencies"],
  ["flutter_lints", "^2.0.3", "2.0.3", "6.0.0", "majeur", "dev_dependencies"],
];
const inventaire = (web, mobile, nodeLts, flutterStable, eol) =>
  `### Application web (racine, npm d'après \`package-lock.json\`)

${table(web.map((r) => row(...r)))}

Environnement :
- Node.js : 18.19.0 (\`.nvmrc\`), \`>=18\` (\`engines\` de \`package.json\`), \`node:18-alpine\` (\`Dockerfile\`) ; dernière version LTS : ${nodeLts} ; fin de support de la version déclarée : ${eol}.

### Application Flutter (\`mobile/\`, pub d'après \`mobile/pubspec.lock\`)

${table(mobile.map((r) => row(...r)))}

Environnement :
- SDK Dart : \`>=3.1.0 <4.0.0\` (\`environment.sdk\` de \`mobile/pubspec.yaml\`).
- Flutter : \`>=3.13.0\` (\`environment.flutter\` de \`mobile/pubspec.yaml\`), épinglé en 3.13.9 (\`mobile/.fvmrc\`) ; dernière version stable : ${flutterStable} ; fin de support : non déterminé (aucun calendrier publié par endoflife.date).`;

const verifications = `### Application web
- \`npm test\`, \`npm run lint\`, \`npm run build\` (scripts de \`package.json\`)

### Application Flutter (\`mobile/\`)
- \`flutter analyze\`, \`flutter test\` (stack Flutter)`;

const nominalParts = {
  Synthèse: `- Dépendances : 15 majeur, 11 mineur, 0 correctif, 2 à jour.
- Plan : 3 étapes.
- Effort global : **élevé**, justifié par 1 rupture (R1) et 1 fichier impacté, et la montée de Node.js.
- Fin de support passée : Node.js 18 (\`.nvmrc\`), depuis le 2025-04-30.`,
  "Inventaire des versions": inventaire(webRows, mobileRows, "24.11.0 (endoflife.date)", "non déterminé (source injoignable)", "2025-04-30 (endoflife.date)"),
  "Cibles retenues": `1. \`express\` 4.18.2 → 5.1.0 (corrige S3, première version corrigée 4.19.2).
2. Lot mineur et correctif : \`pg\`, \`tsx\`, \`typescript\`, \`sqflite\`…
3. \`react-dom\` 17.0.2 → 19.2.0, avec \`react\` (dépendance pair).`,
  "Ruptures et impacts": `### R1 : suppression de \`ReactDOM.render\` (\`react-dom\` 17 → 19)

- Source : non vérifiée (aucune source consultée).
- Impacts (1 occurrence) : \`src/web/main.tsx:5\`.`,
  "Plan de montée": `### Étape 1 : express 5 (S3)

- Paquets : \`express\` 4.18.2 → 5.1.0 (application web)
- Commandes : \`npm install express@5.1.0\`
- Ruptures à traiter : aucune
- Vérification avant l'étape suivante : \`npm test\`

### Étape 2 : react 19

- Paquets : \`react\` 17.0.2 → 19.2.0, \`react-dom\` 17.0.2 → 19.2.0
- Commandes : \`npm install react@19.2.0 react-dom@19.2.0\`
- Ruptures à traiter : R1
- Vérification avant l'étape suivante : \`npm test\`, \`npm run build\`

### Étape 3 : http 1

- Paquets : \`http\` 0.13.6 → 1.6.0 (\`mobile/\`)
- Commandes : \`flutter pub add http:^1.6.0\`
- Ruptures à traiter : aucune
- Vérification avant l'étape suivante : \`flutter analyze\`, \`flutter test\``,
  Vérifications: verifications,
  "Points non déterminés": "- Dernière version stable de Flutter : non déterminé (source injoignable).",
};
const nominalHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 18776c7";

// sampleCase <cas> <livrable conforme> <[nom du correcteur, livrable fautif]…>
function sampleCase(c, good, mutations) {
  const errors = [];
  for (const [key, g] of Object.entries(graders)) {
    if (!key.startsWith(`${c}/`) || g.fields.type !== "regex" || !(g.fields.target ?? "").includes("montee-version.md")) continue;
    if (!passes(g, good)) errors.push(`livrable conforme refusé par ${key.slice(c.length + 1)}`);
  }
  for (const [file, bad] of mutations) {
    const g = graders[`${c}/${file}`];
    if (!g) errors.push(`correcteur ${file} introuvable`);
    else if (passes(g, bad)) errors.push(`livrable fautif accepté par ${file}`);
  }
  if (errors.length) ko(`${c} : livrables d'exemple`, errors);
  else ok(`${c} : livrable conforme accepté, ${mutations.length} livrables fautifs refusés`);
}

const nominalDoc = livrable(nominalHeader, nominalParts);
const swap = (parts, key, from, to) => ({ ...parts, [key]: parts[key].replace(from, to) });
sampleCase(nominal, nominalDoc, [
  ["ca02-sections-dans-l-ordre.md", nominalDoc.replace("## Cibles retenues", "## Cibles").replace("## Synthèse", "## Cibles retenues")],
  ["ca03-ligne-react.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "| `react` | `^17.0.2` | 17.0.2 |", "| `react` | `^17.0.2` | non déterminé |"))],
  ["ca03-ligne-react.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "| 17.0.2 | 19.2.0 | majeur | `dependencies` |", "| 17.0.2 | 19.2.0 | mineur | `dependencies` |"))],
  ["ca03-ligne-types-react-dev.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "| 19.2.2 | majeur | `devDependencies` |", "| 19.2.2 | majeur | `dependencies` |"))],
  ["ca03-ligne-http-pub.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "| `http` | `^0.13.6` | 0.13.6 | 1.6.0 | majeur | `dependencies` |", "| `http` | `^0.13.6` | 0.13.6 | 1.6.0 | majeur | `dev_dependencies` |"))],
  ["ca03-toutes-les-dependances-directes.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", /\n\| `geolocator`[^\n]*/, ""))],
  ["ca04-node-et-ses-fichiers.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "(`Dockerfile`)", ""))],
  ["ca05-flutter-et-ses-fichiers.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "(`mobile/.fvmrc`)", ""))],
  ["ca11-s3-en-tete-des-cibles.md", livrable(nominalHeader, swap(nominalParts, "Cibles retenues", /^1\. (.*)\n2\. (.*)$/m, "1. $2\n2. $1"))],
  ["ca11-s3-en-tete-du-plan.md", livrable(nominalHeader, swap(nominalParts, "Plan de montée", "### Étape 1 : express 5 (S3)", "### Étape 1 : express 5"))],
  ["ca11-s1-non-cite.md", livrable(nominalHeader, swap(nominalParts, "Cibles retenues", "corrige S3", "corrige S1 et S3"))],
  // Défauts observés en eval r12 : source « métadonnées du registre », rupture sans impacts, étape incomplète
  ["ca12-chaque-rupture-sourcee.md", livrable(nominalHeader, swap(nominalParts, "Ruptures et impacts", "- Source : non vérifiée (aucune source consultée).", "- Source : métadonnées du registre npm (peerDependencies)."))],
  ["ca12-ruptures-identifiees.md", livrable(nominalHeader, { ...nominalParts, "Ruptures et impacts": "Aucune rupture." })],
  ["ca13-chaque-rupture-impacts.md", livrable(nominalHeader, swap(nominalParts, "Ruptures et impacts", "- Impacts (1 occurrence) : `src/web/main.tsx:5`.", "- Impacts : non déterminés."))],
  ["ca15-chaque-etape-complete.md", livrable(nominalHeader, swap(nominalParts, "Plan de montée", "- Ruptures à traiter : R1\n", ""))],
  ["ca15-chaque-etape-complete.md", livrable(nominalHeader, swap(nominalParts, "Plan de montée", "- Paquets : `express` 4.18.2 → 5.1.0 (application web)", "- Paquets : `express`"))],
  ["ca04-node-et-ses-fichiers.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "`>=18` (`engines` de `package.json`), ", ""))],
  ["ca13-react-dom-render.md", livrable(nominalHeader, swap(nominalParts, "Ruptures et impacts", "`src/web/main.tsx:5`", "`src/web/main.tsx:7`"))],
  ["ca15-commande-npm.md", livrable(nominalHeader, swap(nominalParts, "Plan de montée", "react-dom@19.2.0", "react-dom"))],
  ["ca15-commande-flutter-pub.md", livrable(nominalHeader, swap(nominalParts, "Plan de montée", "flutter pub add http:^1.6.0", "modifier mobile/pubspec.yaml"))],
  ["ca16-verifications.md", livrable(nominalHeader, swap(nominalParts, "Vérifications", "`flutter analyze`, ", ""))],
  ["ca21-sans-chiffrage.md", livrable(nominalHeader, swap(nominalParts, "Synthèse", "**élevé**", "**élevé** (environ 5 jours)"))],
  ["ca27-sous-sections-par-application.md", livrable(nominalHeader, swap(nominalParts, "Inventaire des versions", "### Application Flutter", "Application Flutter"))],
  ["adr001-en-tete-outil-date-commit.md", livrable("Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0", nominalParts)],
  ["adr001-arbre-propre-sans-mention.md", livrable(`${nominalHeader} · modifications non commitées`, nominalParts)],
  ["adr001-aucune-adresse-email.md", livrable(nominalHeader, swap(nominalParts, "Points non déterminés", "- Dernière", "- Contributrice lea.marchetti@example.invalid.\n- Dernière"))],
  ["ca25-secret-absent-du-livrable.md", livrable(nominalHeader, swap(nominalParts, "Points non déterminés", "- Dernière", "- Valeur FIELDOPS_FAUX_SECRET_7f3a.\n- Dernière"))],
]);

check(
  "CA11 S1 hors des sections du plan",
  `${nominal}/ca11-s1-non-cite.md`,
  [livrable(nominalHeader, swap(nominalParts, "Points non déterminés", "- Dernière", "- Le constat S1 (code) est hors périmètre.\n- Dernière"))],
  [
    livrable(nominalHeader, swap(nominalParts, "Synthèse", "- Plan", "- S1 non traité.\n- Plan")),
    livrable(nominalHeader, swap(nominalParts, "Plan de montée", "(S3)", "(S1, S3)")),
  ],
);

// Registre injoignable : versions publiées « non déterminé »
const nd = "non déterminé";
const offlineRows = (rows) => rows.map(([n, c, i, , , u]) => [n, c, i, nd, nd, u]);
const offlineParts = {
  Synthèse: "- Dépendances : écarts non déterminés (registre injoignable).\n- Plan : aucune étape.\n- Effort global : **faible**, aucune rupture.",
  "Inventaire des versions": inventaire(offlineRows(webRows), offlineRows(mobileRows), `${nd} (endoflife.date injoignable)`, nd, nd),
  "Cibles retenues": "Aucune cible : dernières versions publiées non déterminées.",
  "Ruptures et impacts": "Aucune rupture.",
  "Plan de montée": "Le plan ne contient aucune étape.",
  Vérifications: verifications,
  "Points non déterminés": "- Registre npm et pub.dev injoignables : versions installées tirées du lockfile (`package-lock.json`, `mobile/pubspec.lock`), dernières versions non déterminées.",
};
const offlineHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0";
const offlineDoc = livrable(offlineHeader, offlineParts);
const c07 = "montee-version-ca07-registre-injoignable";
sampleCase(c07, offlineDoc, [
  ["ca07-versions-du-lockfile.md", livrable(offlineHeader, swap(offlineParts, "Inventaire des versions", "| `react` | `^17.0.2` | 17.0.2 | non déterminé | non déterminé |", "| `react` | `^17.0.2` | 17.0.2 | 19.2.0 | majeur |"))],
  ["ca07-repli-signale.md", livrable(offlineHeader, { ...offlineParts, "Points non déterminés": "- Aucun." })],
  ["ca06-aucune-date-de-memoire.md", livrable(offlineHeader, swap(offlineParts, "Inventaire des versions", "fin de support de la version déclarée : non déterminé", "fin de support de la version déclarée : 2025-04-30"))],
  ["ca11-absent-aucun-avis.md", livrable(offlineHeader, swap(offlineParts, "Cibles retenues", "Aucune cible", "Aucune cible (S3)"))],
  ["ca16-verifications.md", livrable(offlineHeader, swap(offlineParts, "Vérifications", "`npm run lint`, ", ""))],
]);

// Cible react-dom 19
const c08 = "montee-version-ca08-cible-react-dom";
const argParts = {
  ...nominalParts,
  Synthèse: "- Dépendances : 1 majeur.\n- Plan : 1 étape.\n- Effort global : **moyen**, 1 rupture (R1), 1 fichier impacté.",
  "Cibles retenues": "1. `react-dom` 17.0.2 → 19.2.0, avec `react` 17.0.2 → 19.2.0 (dépendance pair de `react-dom` 19.2.0, registre npm).",
  "Plan de montée": `### Étape 1 : react-dom 19

- Paquets : \`react\` 17.0.2 → 19.2.0, \`react-dom\` 17.0.2 → 19.2.0
- Commandes : \`npm install react@19.2.0 react-dom@19.2.0\`
- Ruptures à traiter : R1
- Vérification avant l'étape suivante : \`npm test\``,
};
const argHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0 · Argument : `react-dom 19`";
const argDoc = livrable(argHeader, argParts);
sampleCase(c08, argDoc, [
  ["ca24-argument-en-tete.md", livrable("Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0", argParts)],
  ["ca08-aucune-autre-cible.md", livrable(argHeader, swap(argParts, "Cibles retenues", "registre npm).", "registre npm).\n2. Node.js 18 → 24."))],
  ["ca08-aucune-autre-commande.md", livrable(argHeader, swap(argParts, "Plan de montée", "react-dom@19.2.0`", "react-dom@19.2.0 express@5.1.0`"))],
  // Défaut observé en eval : cible « recommandée » d'alignement des types, non exigée par react-dom
  ["ca08-aucune-autre-cible.md", livrable(argHeader, swap(argParts, "Cibles retenues", "registre npm).", "registre npm).\n2. Alignement des types (recommandé) : `@types/react` 17.0.70 → 19.3.0."))],
  ["ca08-au-plus-deux-cibles.md", livrable(argHeader, swap(argParts, "Cibles retenues", "registre npm).", "registre npm).\n2. `react` 17.0.2 → 19.2.0.\n3. Alignement recommandé."))],
  ["ca08-au-plus-deux-cibles.md", livrable(argHeader, swap(argParts, "Cibles retenues", "registre npm).", "registre npm).\n- `react` 17.0.2 → 19.2.0.\n- Alignement recommandé."))],
  ["ca08-chaque-cible-nomme-react.md", livrable(argHeader, swap(argParts, "Cibles retenues", "registre npm).", "registre npm).\n   - Alignement recommandé des types."))],
  ["ca08-aucune-autre-commande.md", livrable(argHeader, swap(argParts, "Plan de montée", "react-dom@19.2.0`", "react-dom@19.2.0` puis `npm install --save-dev @types/react@19.3.0`"))],
  ["ca08-plan-sans-autre-paquet.md", livrable(argHeader, swap(argParts, "Plan de montée", "`react-dom` 17.0.2 → 19.2.0\n", "`react-dom` 17.0.2 → 19.2.0, `@types/react` 17.0.70 → 19.3.0\n"))],
  ["ca09-version-visee-resolue.md", livrable(argHeader, { ...argParts, "Cibles retenues": "1. `react-dom` 17.0.2 → 19 (version précise non déterminée)." })],
  ["ca14-react-entraine.md", livrable(argHeader, swap(argParts, "Plan de montée", "react@19.2.0 ", ""))],
  ["ca13-main-tsx-ligne-5.md", livrable(argHeader, swap(argParts, "Ruptures et impacts", "src/web/main.tsx:5", "src/web/App.tsx:5"))],
  ["ca15-commande-npm.md", livrable(argHeader, swap(argParts, "Plan de montée", "npm install react@19.2.0 react-dom@19.2.0", "pnpm add react@19.2.0 react-dom@19.2.0"))],
]);

// Cible déjà atteinte
const c18 = "montee-version-ca18-cible-deja-atteinte";
const reachedParts = {
  ...nominalParts,
  Synthèse: "- `express` est déjà à la version visée 4.18.2 : aucune montée nécessaire.\n- Plan : aucune étape.\n- Effort global : **faible**.",
  "Cibles retenues": "1. `express` 4.18.2 → 4.18.2 : version visée déjà atteinte.",
  "Ruptures et impacts": "Aucune rupture.",
  "Plan de montée": "Le plan ne contient aucune étape : la cible est déjà à la version visée.",
};
const reachedHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0 · Argument : `express 4.18.2`";
sampleCase(c18, livrable(reachedHeader, reachedParts), [
  ["ca18-plan-sans-etape.md", livrable(reachedHeader, { ...reachedParts, "Plan de montée": "### Étape 1 : express\n\n- Commandes : `npm install express@4.18.2`" })],
  ["ca18-plan-sans-etape.md", livrable(reachedHeader, { ...reachedParts, "Plan de montée": "1. Rien à faire." })],
  ["ca08-cible-express-seule.md", livrable(reachedHeader, swap(reachedParts, "Cibles retenues", "atteinte.", "atteinte.\n2. `react` 17.0.2 → 19.2.0."))],
  ["ca24-argument-en-tete.md", livrable("Outil : wf-montee-version · Date : 2026-10-19 · Commit : 2fc99c0", reachedParts)],
]);

// Projet mixte sans lockfile
const c19 = "montee-version-ca19-ca22-projet-mixte-sans-lockfile";
const mixedParts = {
  Synthèse: "- Dépendances : 1 majeur, 1 correctif, 1 à jour.\n- Plan : 1 étape.\n- Effort global : **moyen**, 1 rupture (R1), 2 fichiers impactés.",
  "Inventaire des versions": `### Application JS/TS (racine, gestionnaire non déterminé : aucun lockfile)

${table([row("dayjs", "^1.11.0", nd, "1.11.18", "non déterminé", "dependencies"), row("lodash", "^3.10.1", nd, "4.17.21", "majeur", "dependencies"), "| `x'$(touch pwned)'` | `^1.0.0` | non déterminé | non vérifié (nom invalide) | non déterminé | `dependencies` |", row("typescript", "^4.9.5", nd, "5.9.3", "majeur", "devDependencies")])}

### Partie PHP (\`composer.json\`) : stack non couverte en v1`,
  "Cibles retenues": "1. `lodash` ^3.10.1 → 4.17.21.",
  "Ruptures et impacts": "### R1 : suppression de `_.pluck` (lodash 4)\n\n- Source : non vérifiée.\n- Impacts (2 occurrences) : `src/index.ts:7`, `src/report.ts:5`.",
  "Plan de montée": "### Étape 1 : lodash 4\n\n- Paquets : `lodash` ^3.10.1 → 4.17.21\n- Commandes : non déterminé (aucun lockfile)\n- Ruptures à traiter : R1\n- Vérification avant l'étape suivante : non déterminé (aucun script de test ni de build).",
  Vérifications: "Aucun script de test ni de build identifié dans `package.json`.",
  "Points non déterminés": "- Aucun lockfile : versions installées non déterminées.\n- Aucun script de test ni de build : vérifications non déterminées.",
};
const mixedHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : hors git";
sampleCase(c19, livrable(mixedHeader, mixedParts), [
  ["ca19-installee-non-determinee.md", livrable(mixedHeader, swap(mixedParts, "Inventaire des versions", "| `lodash` | `^3.10.1` | non déterminé |", "| `lodash` | `^3.10.1` | 3.10.1 |"))],
  ["ca03-nom-invalide-non-verifie.md", livrable(mixedHeader, swap(mixedParts, "Inventaire des versions", /\n\| `x'[^\n]*/, ""))],
  ["ca19-points-non-determines.md", livrable(mixedHeader, { ...mixedParts, "Points non déterminés": "- Aucun script de test." })],
  ["ca17-aucune-commande-inventee.md", livrable(mixedHeader, { ...mixedParts, Vérifications: "- `npm test`" })],
  ["ca17-aucune-commande-inventee.md", livrable(mixedHeader, { ...mixedParts, Vérifications: "- `npx tsc --noEmit`" })],
  ["ca22-php-non-couverte.md", livrable(mixedHeader, swap(mixedParts, "Inventaire des versions", "stack non couverte en v1", "stack PHP"))],
  ["ca22-aucune-cible-php.md", livrable(mixedHeader, swap(mixedParts, "Cibles retenues", "4.17.21.", "4.17.21.\n2. `laravel/framework` 8 → 12."))],
  ["ca22-partie-js-traitee.md", livrable(mixedHeader, { ...mixedParts, "Cibles retenues": "Aucune cible." })],
  ["ca13-pluck-impacts.md", livrable(mixedHeader, swap(mixedParts, "Ruptures et impacts", ", `src/report.ts:5`", ""))],
  ["adr001-hors-git.md", livrable("Outil : wf-montee-version · Date : 2026-10-19 · Commit : 1234567", mixedParts)],
]);

// Monorepo pnpm
const c27 = "montee-version-ca27-monorepo-pnpm";
const pnpmParts = {
  Synthèse: "- Dépendances : 4 majeur, 1 mineur, 2 à jour.\n- Plan : 2 étapes.\n- Effort global : **moyen**, 1 rupture (R1), 1 fichier impacté.",
  "Inventaire des versions": `Gestionnaire : pnpm d'après \`pnpm-lock.yaml\`. Node.js : 20.11.1 (\`.node-version\`), \`>=20\` (\`engines\` de \`package.json\`) ; dernière version LTS : 24.11.0 (endoflife.date).

### \`apps/web\` (\`@fieldops/web\`)

${table([row("react", "^17.0.2", "17.0.2", "19.2.0", "majeur", "dependencies"), row("dayjs", "^1.11.10", "1.11.10", "1.11.18", "correctif", "dependencies")])}

### \`apps/admin\` (\`@fieldops/admin\`)

${table([row("react", "^18.2.0", "18.2.0", "19.2.0", "majeur", "dependencies")])}

Versions différentes entre applications : \`react\` 17.0.2 (\`apps/web\`) et 18.2.0 (\`apps/admin\`).`,
  "Cibles retenues": "1. `react` 17.0.2 → 19.2.0 (`apps/web`).\n2. `react` 18.2.0 → 19.2.0 (`apps/admin`).",
  "Plan de montée": "### Étape 1 : react 19 (apps/web)\n\n- Commandes : `pnpm --filter @fieldops/web add react@19.2.0 react-dom@19.2.0`\n- Vérification : `pnpm --filter @fieldops/web test`",
  Vérifications: "### `apps/web`\n- `pnpm --filter @fieldops/web test`, `pnpm --filter @fieldops/web build`\n\n### `apps/admin`\n- `pnpm --filter @fieldops/admin build`",
};
const pnpmHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 822183b";
sampleCase(c27, livrable(pnpmHeader, pnpmParts), [
  ["ca27-sous-section-admin.md", livrable(pnpmHeader, swap(pnpmParts, "Inventaire des versions", "### `apps/admin` (`@fieldops/admin`)", "Administration"))],
  ["ca27-versions-differentes-citees.md", livrable(pnpmHeader, swap(pnpmParts, "Inventaire des versions", "Versions différentes entre applications", "Note"))],
  ["ca03-lockfile-pnpm.md", livrable(pnpmHeader, swap(pnpmParts, "Inventaire des versions", "| `react` | `^18.2.0` | 18.2.0 |", "| `react` | `^18.2.0` | non déterminé |"))],
  ["ca04-node-version.md", livrable(pnpmHeader, swap(pnpmParts, "Inventaire des versions", "(`.node-version`)", "(`.nvmrc`)"))],
  ["ca15-commande-pnpm.md", livrable(pnpmHeader, swap(pnpmParts, "Plan de montée", "pnpm --filter @fieldops/web add", "npm install"))],
  ["ca15-aucun-autre-gestionnaire.md", livrable(pnpmHeader, swap(pnpmParts, "Plan de montée", "pnpm --filter @fieldops/web add", "npm install"))],
  ["ca16-scripts-pnpm.md", livrable(pnpmHeader, { ...pnpmParts, Vérifications: "- `pnpm --filter @fieldops/admin build`" })],
]);

// Relance
const c23 = "montee-version-ca23-relance";
const relaunchHeader = "Outil : wf-montee-version · Date : 2026-10-19 · Commit : 7863f6e";
const relaunchDoc = livrable(relaunchHeader, offlineParts);
sampleCase(c23, relaunchDoc, [
  ["ca23-une-seule-synthese.md", `${relaunchDoc}\n${relaunchDoc}`],
  ["ca23-version-perimee-retiree.md", livrable(relaunchHeader, swap(offlineParts, "Points non déterminés", "- Registre", "- Ancienne version 16.14.0.\n- Registre"))],
  ["ca23-date-mise-a-jour.md", livrable("Outil : wf-montee-version · Date : 2026-01-15 · Commit : 7863f6e", offlineParts)],
  ["ca23-en-tete-commit-actualise.md", livrable("Outil : wf-montee-version · Date : 2026-10-19 · Commit : 0000000", offlineParts)],
  ["ca23-version-actuelle-du-lockfile.md", livrable(relaunchHeader, swap(offlineParts, "Inventaire des versions", "| `react` | `^17.0.2` | 17.0.2 |", "| `react` | `^16.14.0` | 16.14.0 |"))],
]);
// Faux verts : l'ancien livrable déposé par le scaffold ne doit satisfaire aucun
// correcteur positif (contains, count) du cas, sinon celui-ci ne prouve rien.
{
  const scaffold = readFileSync(join(evals, c23, "scaffold.sh"), "utf8");
  const old = /cat >docs\/wf\/montee-version\.md <<'MD'\n([\s\S]*?)\nMD\n/.exec(scaffold)?.[1];
  const errors = [];
  if (!old) errors.push("ancien livrable introuvable dans scaffold.sh");
  else
    for (const [key, g] of Object.entries(graders)) {
      if (!key.startsWith(`${c23}/`) || g.fields.type !== "regex" || !(g.fields.target ?? "").includes("montee-version.md")) continue;
      if ((g.fields.match ?? "contains") === "not_contains") continue;
      if (passes(g, old)) errors.push(`${key.slice(c23.length + 1)} réussit sur l'ancien livrable du scaffold`);
    }
  if (errors.length) ko(`${c23} : correcteurs positifs discriminants`, errors);
  else ok(`${c23} : aucun correcteur positif ne réussit sur l'ancien livrable du scaffold`);
}
check(
  "CA23 aucun doublon",
  `${c23}/ca23-aucun-doublon.md`,
  ["docs/wf/montee-version.md", "docs/wf/montee-version.md\n.claude/settings.json"],
  ["docs/wf/montee-version.md\ndocs/wf/montee-version-2026-10-19.md", "docs/wf/montee-version-2.md"],
);

// Messages finaux sans livrable
check(
  "CA9 paquet absent",
  "montee-version-ca09-paquet-absent/ca09-paquet-absent-signale.md",
  ["`lodash` n'est pas une dépendance du projet (dernière version publiée : 4.17.21, registre npm) : aucun livrable n'a été écrit."],
  ["Le plan de montée de lodash est écrit dans docs/wf/montee-version.md."],
);
check(
  "CA9 dernière version citée",
  "montee-version-ca09-paquet-absent/ca09-derniere-version-citee.md",
  ["`lodash` n'est pas une dépendance du projet (dernière version publiée : 4.17.21, registre npm)."],
  ["`lodash` n'est pas une dépendance du projet.", "`lodash` 4 n'est pas une dépendance du projet : react 17.0.2 est installé."],
);
check(
  "CA9 version inexistante",
  "montee-version-ca09-version-inexistante/ca09-version-inexistante-signalee.md",
  ["La version `99.0.0` de `react` n'existe pas sur le registre npm (dernière version publiée : 19.2.0) : aucun livrable n'a été écrit."],
  ["Plan écrit pour react 19.2.0."],
);
check(
  "CA9 dernière version de react",
  "montee-version-ca09-version-inexistante/ca09-derniere-version-citee.md",
  ["La version 99.0.0 n'existe pas (dernière version publiée : 19.2.0)."],
  ["La version 99.0.0 n'existe pas ; version installée 17.0.2.", "Versions 18.3.1 et 19.0.0 publiées, 99.0.0 introuvable."],
);
check(
  "CA26 sans manifeste",
  "montee-version-ca26-sans-manifeste/ca26-sans-manifeste-signale.md",
  ["Aucun manifeste de dépendances trouvé : aucun livrable n'a été écrit."],
  ["Plan de montée écrit dans docs/wf/montee-version.md.", "Aucun manifeste de dépendances trouvé."],
);

// --- 4 : commandes prescrites par la skill ------------------------------------------

const skillPath = join(root, "skills", "wf-montee-version", "SKILL.md");
if (!existsSync(skillPath)) {
  ko("skills/wf-montee-version/SKILL.md introuvable : commandes de la skill non vérifiées");
} else {
  const skill = readFileSync(skillPath, "utf8");
  const commands = [...skill.matchAll(/^```bash\n([\s\S]*?)^```$/gm)].map((m) => m[1].trimEnd());
  if (commands.length === 0) ko("aucun bloc ```bash dans la skill");
  // Les commandes réellement lancées ont leur heredoc rempli de noms de paquets :
  // un nom comme vite, tsx ou make, seul sur sa ligne, ne doit pas passer pour une
  // exécution. On vérifie donc aussi les blocs remplis de noms d'outils.
  const body = ["vite", "vitest 1.0.1", "tsx 4.6.0", "make", "eslint", "typescript", "jest", "node", "npm", "yarn", "pnpm", "react-dom 19"].join("\n");
  const filled = commands.map((b) => b.replace(/(<<'WF_NOMS_7c1e'\n)[\s\S]*?(\nWF_NOMS_7c1e$)/m, `$1${body}$2`));
  if (!filled.some((b, i) => b !== commands[i])) ko("aucun heredoc WF_NOMS_7c1e à remplir dans les blocs de la skill");
  commands.push(...filled.filter((b, i) => b !== commands[i]));
  check(
    "CA20 heredoc : corps ignoré, commandes suivantes détectées",
    `${nominal}/ca20-ni-installation-ni-execution.md`,
    [bash(`while read -r p; do echo "$p"; done <<'WF_NOMS_7c1e'\nvite\ntsx\nmake\nWF_NOMS_7c1e`)],
    [
      bash(`while read -r p; do echo "$p"; done <<'WF_NOMS_7c1e'\nvite\nWF_NOMS_7c1e\nnpm install`),
      bash(`while read -r p; do echo "$p"; done <<'AUTRE'\nvite\nAUTRE`),
      bash("cat <<WF_NOMS_7c1e\nx\nWF_NOMS_7c1e\nvite"),
    ],
  );
  for (const c of cases) {
    for (const file of [
      "ca20-ni-installation-ni-execution.md",
      "ca20-ni-branche-ni-commit.md",
      "ca01-aucune-modification-par-bash.md",
      "ca01-curl-sans-ecriture.md",
      "ca25-fichier-env-non-lu-bash.md",
      "ca11-aucune-recherche-de-vulnerabilites-bash.md",
      "ca11-absent-aucune-recherche-bash.md",
    ]) {
      if (graders[`${c}/${file}`]) check("commandes de la skill permises", `${c}/${file}`, commands.map(bash), []);
    }
  }
  // Chaque correcteur « registre interrogé » doit être satisfait par le bloc de la
  // skill qui interroge ce registre, pris seul (pas par la concaténation des blocs).
  for (const [key, domain] of [
    [`${nominal}/ca03-registre-npm-interroge.md`, "registry.npmjs.org"],
    [`${nominal}/ca03-registre-pub-dev-interroge.md`, "pub.dev/api/"],
    [`${nominal}/ca06-calendrier-consulte.md`, "endoflife.date"],
  ]) {
    const blocks = commands.filter((b) => b.includes(domain));
    if (blocks.length === 0) ko(`aucun bloc de la skill n'interroge ${domain}`);
    else check(`commandes de la skill exigées (${domain}, chaque bloc seul)`, key, blocks.map(bash), []);
  }
  // Les commandes de registre, une fois le paquet substitué, visent bien l'adresse du paquet
  const npmBlock = commands.find((b) => b.includes("registry.npmjs.org"));
  if (npmBlock) {
    for (const [key, pkg] of [
      ["montee-version-ca09-paquet-absent/ca09-registre-interroge.md", "lodash"],
      ["montee-version-ca09-version-inexistante/ca09-registre-interroge.md", "react"],
      [`${c08}/ca14-metadonnees-consultees.md`, "react-dom"],
    ]) {
      check("commande npm de la skill, paquet substitué", key, [bash(npmBlock.replaceAll("<paquet>", pkg))], []);
    }
  } else ko("aucune commande de la skill n'interroge registry.npmjs.org");
}

process.exit(failures === 0 ? 0 : 1);
