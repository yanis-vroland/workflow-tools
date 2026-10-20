#!/usr/bin/env node
// Vérifie les motifs des correcteurs des evals de wf-recette (evals/recette-*/),
// sans modèle.
//
// 1. Chaque motif (`pattern` avec ses `flags`, `input_match` sans drapeau) est
//    compilé comme le fait `claude plugin eval` (new RegExp) : un motif invalide
//    n'apparaîtrait sinon qu'à la notation.
// 2. Les listes blanches Bash (`…-aucune-commande-hors-liste`) admettent les
//    commandes prescrites par la skill et rejettent toute autre commande.
// 3. Quelques correcteurs regex sont vérifiés sur des exemples positifs et
//    négatifs de livrable.
//
// Usage : node tests/correcteurs/wf-recette.mjs

import { readdirSync, readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..", "..");
const evals = join(root, "evals");
let failures = 0;
const fail = (message) => {
  failures++;
  console.log(`ÉCHEC  correcteurs wf-recette : ${message}`);
};

// Lit les clés simples du frontmatter (valeurs entre apostrophes YAML, '' = ')
function grader(path) {
  const front = readFileSync(path, "utf8").split(/^---$/m)[1] ?? "";
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

// --- 1. Compilation de tous les motifs --------------------------------------------

const cases = readdirSync(evals).filter((d) => d.startsWith("recette-"));
if (cases.length === 0) fail("aucun cas evals/recette-*");
const compiled = {};
for (const c of cases) {
  for (const f of readdirSync(join(evals, c, "graders"))) {
    const g = grader(join(evals, c, "graders", f));
    for (const key of ["pattern", "input_match"]) {
      if (g[key] === undefined) continue;
      try {
        compiled[`${c}/${f}`] = new RegExp(g[key], key === "pattern" ? g.flags || "" : "");
      } catch (e) {
        fail(`${c}/${f} : motif invalide (${e.message})`);
      }
    }
  }
}

const re = (c, f) => {
  const r = compiled[`${c}/${f}.md`];
  if (!r) fail(`${c}/${f} : correcteur introuvable`);
  return r ?? /(?!)/;
};
const expect = (c, f, text, want, label) => {
  if (re(c, f).test(text) !== want) fail(`${c}/${f} : ${label} (attendu ${want ? "trouvé" : "absent"})`);
};

// --- 2. Listes blanches Bash -------------------------------------------------------

const bash = (command) => JSON.stringify({ command, description: "Commande d'exemple" });
const always = ["git rev-parse --short HEAD", "git status --porcelain", "date +%F"];
const withRef = (ref) => [
  `git log -1 --format=%h ${ref} --`,
  `git diff --name-only ${ref} HEAD`,
  `git show ${ref}:docs/wf/specs-tickets.md`,
];
const forbidden = [
  "npm test",
  "mkdir -p docs/wf",
  "cat .env",
  "git status --porcelain && npm test",
  "git diff v1.3.0 HEAD",
  "ls",
];
for (const c of cases) {
  const name = readdirSync(join(evals, c, "graders")).find((f) => f.endsWith("-aucune-commande-hors-liste.md"));
  if (!name) {
    fail(`${c} : aucun correcteur …-aucune-commande-hors-liste`);
    continue;
  }
  const prompt = readFileSync(join(evals, c, "prompt.md"), "utf8").trim();
  const ref = prompt.split(/\s+/)[1];
  // Référence inconnue (CA17) : seule sa vérification est permise, rien n'est
  // lu au-delà.
  const refCommands = ref ? withRef(ref) : [];
  const unknownRef = c.includes("reference-inconnue");
  const allowed = [...always, ...(unknownRef ? refCommands.slice(0, 1) : refCommands)];
  const denied = [...forbidden, ...(unknownRef ? refCommands.slice(1) : [])];
  const r = re(c, name.replace(/\.md$/, ""));
  for (const cmd of allowed) if (r.test(bash(cmd))) fail(`${c}/${name} : commande prescrite refusée (${cmd})`);
  for (const cmd of denied) if (!r.test(bash(cmd))) fail(`${c}/${name} : commande interdite admise (${cmd})`);
}

// --- 3. Exemples de livrable --------------------------------------------------------

const row = (id, source, status = "à tester", comment = "") =>
  `| ${id} | Fonctionnalité | Préconditions | 1. Action | Résultat | \`${source}\` | ${status} | ${comment} |`;
const doc = (rows, extra = "") =>
  [
    "# Cahier de recette",
    "",
    "Outil : wf-recette · Date : 2026-10-20 · Commit : abcdef0",
    "",
    "## Périmètre et sources",
    "",
    "## Prérequis",
    "",
    "## Cas de recette",
    "",
    "| ID | Fonctionnalité | Préconditions | Étapes | Résultat attendu | Source | Statut | Commentaire |",
    "|---|---|---|---|---|---|---|---|",
    ...rows,
    "",
    "## Couverture",
    "",
    extra,
    "",
    "## Synthèse de la campagne",
    "",
    "## Points non déterminés",
    "",
  ].join("\n");

const C4 = "recette-ca04-specs-fieldops";
expect(C4, "ca03-aucun-identifiant-mal-forme", doc([row("REC-001", "docs/specs/001-interventions.md#CA1")]), false, "lignes conformes");
expect(C4, "ca03-aucun-identifiant-mal-forme", doc([row("REC-1", "docs/specs/001-interventions.md#CA1")]), true, "identifiant REC-1");
expect(C4, "ca08-nouveaux-cas-a-tester", doc([row("REC-001", "docs/specs/001-interventions.md#CA1")]), false, "cas à tester");
expect(C4, "ca08-nouveaux-cas-a-tester", doc([row("REC-001", "docs/specs/001-interventions.md#CA1", "conforme")]), true, "statut posé par l'outil");
expect(C4, "ca15-aucun-mot-de-passe", doc([], "Campagne limitée aux changements."), false, "« changements » n'est pas « changeme »");
expect(C4, "ca15-aucun-mot-de-passe", doc([], "Mot de passe : changeme"), true, "valeur factice recopiée");
expect(C4, "ca13-chaque-cas-brouillon-marque", doc([row("REC-001", "docs/specs/003-export-pdf.md#CA1") + " "]), true, "cas brouillon sans mention");

const C9 = "recette-ca09-ca16-hors-campagne";
const horsCampagne = (lines) => `### Cas hors campagne\n\n${lines.join("\n")}\n\n### Cas retirés\n\n- Aucun.`;
const rec007 =
  "- REC-007 : Export PDF (`docs/specs/003-export-pdf.md#CA1` (spec brouillon)), dernier statut : bloqué, dernier commentaire : Maquette du PDF attendue.";
expect(C9, "ca09-hors-campagne-rec-007-reconduit", doc([], horsCampagne([rec007])), true, "entrée reconduite");
expect(C9, "ca09-hors-campagne-rec-007-reconduit", doc([], horsCampagne([rec007.replace("Maquette du PDF attendue", "")])), false, "commentaire perdu");
expect(C9, "ca09-hors-campagne-rec-007-reconduit", doc([], horsCampagne([rec007])).replace("2026-10-20", "2026-09-15"), false, "cahier déposé non réécrit");
expect(C9, "ca09-rec-006-reintegre", doc([row("REC-006", "docs/specs/001-interventions.md#CA1", "conforme", "Validé en démo du 10/09")]), true, "cas réintégré");
expect(C9, "ca09-rec-006-reintegre", doc([row("REC-008", "docs/specs/001-interventions.md#CA1")]), false, "nouvel identifiant");
expect(C9, "ca09-un-seul-cas-pour-001-ca1", doc([row("REC-008", "docs/specs/001-interventions.md#CA1")]), true, "nouvel identifiant pour 001#CA1");

if (failures === 0) console.log(`OK     correcteurs wf-recette : ${Object.keys(compiled).length} motifs compilés, listes blanches et exemples vérifiés`);
process.exit(failures ? 1 : 0);
